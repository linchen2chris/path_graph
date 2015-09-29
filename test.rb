path_graph = {A:{B:5,D:5,E:7},B:{C:4},C:{D:8,E:2},D:{C:8,E:6},E:{B:3}};
puts path_graph[:A][:B]
puts path_graph["A".to_sym]["B".to_sym]


def get_path_length(path,path_graph)
    path1 = path.split("-");
    leng = 0;
    for i in 0..(path1.length-2) do
        if(path_graph[path1[i].to_sym][path1[i+1].to_sym] == nil)
            return puts("NO SUCH ROUTE");
	    else
	        leng += path_graph[path1[i].to_sym][path1[i+1].to_sym];
	    end
	end
    puts leng;
end
get_path_length("A-B-C",path_graph)
get_path_length("A-D",path_graph)
get_path_length("A-D-C",path_graph)
get_path_length("A-E-B-C-D",path_graph)
get_path_length("A-E-D",path_graph)

#version 1
def get_num_of_trips_less_stops(start,dest,num_of_stops,path_graph)
	num_of_trips = 0;
	if(num_of_stops < 1)
	    return num_of_trips;
	end
    if(path_graph[start.to_sym][dest.to_sym] != nil)
        num_of_trips += 1;
    end
	path_graph[start.to_sym].each do |key,value|
	    num_of_trips += get_num_of_trips_less_stops(key,dest,num_of_stops-1,path_graph);
	 end
	 return num_of_trips;
end

puts(get_num_of_trips_less_stops("C","C",3,path_graph))

#version 2 
def get_num_of_trips_less_stops(start,dest,num_of_stops,path_graph)
    num_of_trips = 0;
    for i in 1..num_of_stops
        num_of_trips += get_num_of_trips_given_stops(start,dest,i,path_graph)
    end
    return num_of_trips;
end
puts(get_num_of_trips_less_stops("C","C",3,path_graph))

def get_num_of_trips_given_stops(start,dest,num_of_stops,path_graph)
	num_of_trips = 0;
	if(num_of_stops < 1)
	    return num_of_stops;
	end
	if(num_of_stops == 1)
	    if(path_graph[start.to_sym][dest.to_sym] != nil)
	        num_of_trips = 1;
	    else
	        num_of_trips = 0;
	    end
	end
	path_graph[start.to_sym].each do |key,value|
        num_of_trips += get_num_of_trips_given_stops(key,dest,num_of_stops-1,path_graph);
	end
	return num_of_trips;
end

puts(get_num_of_trips_given_stops("A","C",4,path_graph))

def get_shorest_path(start,dest,path_graph,is_first,path)
    if(start == dest && is_first == false)
        return length_of_shorest_path = 0;
    end
	length_of_shorest_path = 100000;
    if(path.include?start == false)
        path.push(start);
	    path_graph[start.to_sym].each do |key,value|
			length_of_transit_path = value + get_shorest_path(key,dest,path_graph,false,path)
		    if(length_of_transit_path < length_of_shorest_path)
			    length_of_shorest_path = length_of_transit_path;
		    end
		end
	end
	return length_of_shorest_path;
end
puts(get_shorest_path("B","B",path_graph,true,[]))
