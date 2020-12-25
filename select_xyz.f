      PROGRAM main
      IMPLICIT NONE
      CHARACTER(LEN=30) :: select_num_file  ! input file
      CHARACTER(LEN=30) :: xyz_file       ! input file
      CHARACTER(LEN=40) :: selected_file  ! output file
      INTEGER   :: f_num, f_xyz, f_selected

      INTEGER,DIMENSION(:),ALLOCATABLE   :: select_num
      INTEGER   :: natoms, iter, jter
      INTEGER   :: ierr
      INTEGER   :: counter=0            ! number of selected coord
      INTEGER   :: line_count=0         ! number of lines of input xyz
      INTEGER   :: coord_dimen          ! number of read in coord
      INTEGER   :: selection
      CHARACTER(LEN=1) :: dummy
      CHARACTER(LEN=2) :: material
      REAL(KIND=8),DIMENSION(:,:,:),ALLOCATABLE  :: coord
      REAL(KIND=8),DIMENSION(:),ALLOCATABLE  :: energy


      PRINT *,"---------------------------------------------"
      PRINT *," You are running structural selection        "
      PRINT *,"---------------------------------------------"

      CALL GET_COMMAND_ARGUMENT(1,xyz_file)
      CALL GET_COMMAND_ARGUMENT(2,select_num_file)

      selected_file = "selected_"//xyz_file


! Read in cluster basic info
      OPEN(NEWUNIT=f_xyz,FILE=xyz_file,STATUS='OLD',IOSTAT=ierr)
      IF (ierr /=0) THEN
        PRINT *, "It appears that you didn't provide the input file."
        PRINT *, "Provide input file as the first argument."
        PRINT *, "provide list of select structures as the second"
        PRINT *, "argument."
        PRINT *, "Exiting programme."
        STOP
      END IF
      READ(f_xyz,*) natoms
      READ(f_xyz,*) dummy
      READ(f_xyz,*) material
      CLOSE(f_xyz)

! Read selected list file, and allocate select_num array
      OPEN(NEWUNIT=f_num,FILE=select_num_file,STATUS='OLD',IOSTAT=ierr)
      IF (ierr /=0) THEN
        PRINT *, "It appears that you didn't provide the input file."
        PRINT *, "Provide input file as the first argument."
        PRINT *, "provide list of select structures as the second"
        PRINT *, "argument."
        PRINT *, "Exiting programme."
        STOP
      END IF
      DO 
        READ(f_num,*,IOSTAT=ierr) 
        IF (ierr /=0) EXIT
        counter = counter + 1
      END DO
      PRINT '("Total selected structure is", I6)', counter
      CLOSE(f_num)
      ALLOCATE(select_num(counter))

! Read in selected list
      OPEN(NEWUNIT=f_num,FILE=select_num_file,STATUS='OLD')
      DO iter=1, SIZE(select_num)
        READ(f_num,*) select_num(iter)
      END DO
      CLOSE(f_num)

      PRINT *, ""
      PRINT *, "Selection list values are:"
      DO iter=1,counter
        PRINT *, select_num(iter)
      END DO
      PRINT *, ""

! Read number of lines of xyz input file, and allocate coord & energy
      OPEN(NEWUNIT=f_xyz,FILE=xyz_file,STATUS='OLD')
      DO 
        READ(f_xyz,*,IOSTAT=ierr) 
        IF (ierr /=0) EXIT
        line_count = line_count + 1
      END DO
      CLOSE(f_xyz)

      coord_dimen = line_count / (natoms+2) 

      PRINT '("Total coordinates read in is", I6)', coord_dimen
      PRINT *, ""

      ALLOCATE(coord(coord_dimen,natoms,3))
      ALLOCATE(energy(coord_dimen))


! Read in all coord

      OPEN(NEWUNIT=f_xyz,FILE=xyz_file,STATUS='OLD')
      read_loop: DO iter=1,coord_dimen
      READ(f_xyz,*)
      READ(f_xyz,*) energy(iter)
        DO jter=1, natoms
          READ(f_xyz,*) material, coord(iter,jter,1)
     &      ,coord(iter,jter,2), coord(iter,jter,3)
        END DO
      END DO read_loop
      CLOSE(f_xyz)

! Output selected coordinates
      OPEN(NEWUNIT=f_selected, FILE=selected_file, ACCESS='append')
      write_loop: DO iter=1,counter
        selection = select_num(iter)
        WRITE(f_selected,*) natoms, "selection:", selection
        WRITE(f_selected,*) energy(selection), "index:", iter-1
        DO jter=1, natoms
          WRITE(f_selected,*) material, coord(selection,jter,1)
     &      ,coord(selection,jter,2), coord(selection,jter,3)
        END DO
      END DO write_loop

      END PROGRAM main
