FC = gfortran

FILTER = main1_filter.f
SORT = main2_sort.f
SELECT = main3_select.f

# Object list
OBJS = $(FILTER).o

all: filter sort select

filter: $(FILTER)
	$(FC) $(FILTER) -o part1_filter.out

sort: $(SORT)
	$(FC) $(SORT) -o part2_sort.out

select: $(SELECT)
	$(FC) $(SELECT) -o part3_select.out

clean:
	rm *.out
