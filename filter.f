! Program to filter xyz files that meets some energy function criteria
! Updated 04 Nov 2020

      PROGRAM main
      IMPLICIT NONE
      INTEGER     :: natoms
      INTEGER     :: f_in, f_out
      CHARACTER(LEN=20)   :: file_in
      CHARACTER(LEN=30)   :: file_out
      INTEGER     :: iter,jter, ending=100
      INTEGER     :: ierr
      INTEGER     :: counter=0,read_in=0
      REAL(KIND=8) :: ene
      CHARACTER(LEN=20)   :: max_val
      REAL(KIND=8) :: max_ene 
      CHARACTER(LEN=2)    :: material

      REAl(KIND=8),DIMENSION(:,:),ALLOCATABLE :: coord

      PRINT *,"---------------------------------------------"
      PRINT *," You are running structural filter           "
      PRINT *,"---------------------------------------------"

      CALL GET_COMMAND_ARGUMENT(1,file_in)
      CALL GET_COMMAND_ARGUMENT(2,max_val)


      OPEN(NEWUNIT=f_in,FILE=file_in,STATUS='OLD',IOSTAT=ierr)
      IF (ierr /=0) THEN
        PRINT *, "It appears that you didn't provide the input file."
        PRINT *, "Provide input file as the first argument."
        PRINT *, "provide cut off energy value as the second argument."
        PRINT *, "Exiting programme."
        STOP
      END IF
      READ(f_in,*) natoms
      CLOSE(f_in)

      file_out = "filtered_"//file_in
      ALLOCATE(coord(natoms,3))

      READ(max_val,*,IOSTAT=ierr) max_ene   ! string to real value
      IF (ierr /=0) THEN
        PRINT *, "It appears that the cut off energy is not specified."
        PRINT *, "Provide input file as the first argument."
        PRINT *, "provide cut off energy value as the second argument."
        PRINT *, "Exiting programme."
        STOP
      END IF



      OPEN(NEWUNIT=f_in,FILE=file_in,STATUS='OLD')
      OPEN(NEWUNIT=f_out,FILE=file_out,STATUS='REPLACE')

      DO 
        READ(f_in,*,IOSTAT=ierr)
        IF (ierr /= 0) EXIT
        READ(f_in,*) ene
        read_in = read_in + 1
        DO jter=1,natoms
          READ(f_in,*) material, coord(jter,1), 
     &      coord(jter,2), coord(jter,3)
        END DO

        IF (ene < max_ene) THEN
          counter = counter + 1
          WRITE(f_out,*)  natoms
          WRITE(f_out,*)  ene
          DO jter=1,natoms
            WRITE(f_out,*) material, coord(jter,1), 
     &        coord(jter,2), coord(jter,3)
          END DO
        END IF

      END DO



      CLOSE(f_in)
      CLOSE(f_out)

      PRINT '("Filter done." )'
      PRINT '("Natoms is", I4, ".")',natoms
      PRINT '("Filter ratio is: " )'
      PRINT '(I6," / " I6)', counter, read_in
      PRINT '(F8.4)', REAL(counter)/REAL(read_in)

      END PROGRAM main
