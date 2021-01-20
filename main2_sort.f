! Program that sorts xyz file according to a sorted list given.
      PROGRAM main
      IMPLICIT NONE
      CHARACTER(LEN=30) :: sort_num_file  ! input file
      CHARACTER(LEN=30) :: xyz_file       ! input file
      CHARACTER(LEN=40) :: sorted_file    ! output file
      INTEGER   :: f_num, f_xyz, f_sorted
      INTEGER,DIMENSION(:),ALLOCATABLE   :: sort_num
      INTEGER   :: counter=0
      INTEGER   :: ierr
      INTEGER   :: rows
      CHARACTER(LEN=1) :: dummy

      INTEGER   :: natoms, iter, jter
      CHARACTER(LEN=2) :: material
      REAL(KIND=8),DIMENSION(:,:),ALLOCATABLE  :: coord
      REAL(KIND=8)  :: ene

      PRINT *,"---------------------------------------------"
      PRINT *,"    You are running structural sort          "
      PRINT *,"            Part 2 of 3                      "
      PRINT *,"            Version 1.0                      "
      PRINT *,"            20-01-2021                       "
      PRINT *,"---------------------------------------------"
      PRINT *,""
      PRINT *,""

      CALL GET_COMMAND_ARGUMENT(1,sort_num_file)
      CALL GET_COMMAND_ARGUMENT(2,xyz_file)

      sorted_file = "sorted_"//xyz_file

! Allocate coord
      OPEN(NEWUNIT=f_xyz,FILE=xyz_file,STATUS='OLD')
      READ(f_xyz,*) natoms
      READ(f_xyz,*) dummy
      READ(f_xyz,*) material
      CLOSE(f_xyz)
      ALLOCATE(coord(natoms,3))

! Read in sort and allocate coord
      OPEN(NEWUNIT=f_num,FILE=sort_num_file,STATUS='OLD')
      DO 
        READ(f_num,*,IOSTAT=ierr) 
        IF (ierr /=0) EXIT
        counter = counter + 1
      END DO
      PRINT '("Total structure is", I6)', counter
      CLOSE(f_num)
      ALLOCATE(sort_num(counter))

      OPEN(NEWUNIT=f_num,FILE=sort_num_file,STATUS='OLD')
      DO iter=1, SIZE(sort_num)
        READ(f_num,*) sort_num(iter)
      END DO
      CLOSE(f_num)

! Start here
      OPEN(NEWUNIT=f_xyz,FILE=xyz_file,STATUS='OLD',ACTION='READ')
      OPEN(NEWUNIT=f_sorted,FILE=sorted_file,STATUS='REPLACE')

      sort_loop: DO iter=1,SIZE(sort_num)
        REWIND(f_xyz)
!        PRINT *, sort_num(iter)*(natoms+2)
        rows = (sort_num(iter)-1)*(natoms+2) ! rows to skip
        DO jter=1, rows
          READ(f_xyz,*) 
        END DO
        READ(f_xyz,*) dummy
        READ(f_xyz,*) ene
        DO jter=1,natoms
          READ(f_xyz,*) dummy, coord(jter,1), 
     &        coord(jter,2), coord(jter,3)
        END DO

        WRITE(f_sorted,*) natoms
        WRITE(f_sorted,*) ene, "index:", iter-1
        DO jter=1,natoms
          WRITE(f_sorted,*) material, coord(jter,1), 
     &        coord(jter,2), coord(jter,3)
        END DO
      END DO sort_loop

      CLOSE(f_xyz)
      CLOSE(f_sorted)


      END PROGRAM main
