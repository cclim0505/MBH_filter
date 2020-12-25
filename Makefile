FC = gfortran

FILTER = filter.f
SORT = sort.f
SELECT = select_xyz.f

# Object list
OBJS = $(FILTER).o

all: filter sort select

filter: $(FILTER)
	$(FC) $(FILTER) -o filter.out

sort: $(SORT)
	$(FC) $(SORT) -o sort.out

select: $(SELECT)
	$(FC) $(SELECT) -o select.out

clean:
	rm *.out
