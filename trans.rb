=begin
Problem one: Trains
The local commuter railroad services a number of towns in Kiwiland. Because of monetary concerns, all of the tracks are 'one-way.' That is, a route from Kaitaia to Invercargill does not imply the existence of a route from Invercargill to Kaitaia. In fact, even if both of these routes do happen to exist, they are distinct and are not necessarily the same distance!

The purpose of this problem is to help the railroad provide its customers with information about the routes. In particular, you will compute the distance along a certain route, the number of different routes between two towns, and the shortest route between two towns.

Input: A directed graph where a node represents a town and an edge represents a route between two towns. The weighting of the edge represents the distance between the two towns. A given route will never appear more than once, and for a given route, the starting and ending town will not be the same town.

Output: For test input 1 through 5, if no such route exists, output 'NO SUCH ROUTE'. Otherwise, follow the route as given; do not make any extra stops! For example, the first problem means to start at city A, then travel directly to city B (a distance of 5), then directly to city C (a distance of 4).
1. The distance of the route A-B-C.
2. The distance of the route A-D.
3. The distance of the route A-D-C.
4. The distance of the route A-E-B-C-D.
5. The distance of the route A-E-D.
6. The number of trips starting at C and ending at C with a maximum of 3 stops. In the sample data below, there are two such trips: C-D-C (2 stops). and C-E-B-C (3 stops).
7. The number of trips starting at A and ending at C with exactly 4 stops. In the sample data below, there are three such trips: A to C (via B,C,D); A to C (via D,C,D); and A to C (via D,E,B).
8. The length of the shortest route (in terms of distance to travel) from A to C.
9. The length of the shortest route (in terms of distance to travel) from B to B.
10. The number of different routes from C to C with a distance of less than 30. In the sample data, the trips are: CDC, CEBC, CEBCDC, CDCEBC, CDEBC, CEBCEBC, CEBCEBCEBC.

Test Input:
For the test input, the towns are named using the first few letters of the alphabet from A to D. A route between two towns (A to B) with a distance of 5 is represented as AB5.
Graph: AB5, BC4, CD8, DC8, DE6, AD5, CE2, EB3, AE7
Expected Output:
Output #1: 9
Output #2: 5
Output #3: 13
Output #4: 22
Output #5: NO SUCH ROUTE
Output #6: 2
Output #7: 3
Output #8: 9
Output #9: 9
Output #10: 7
=end

path_graph = {"A":{"B":5,"D":5,"E":7},"B":{"C":4},"C":{"D":8,"E":2},"D":{"C":8,"E":6},"E":{"B":3}};
 
#解决问题1,2,3,4,5,求给定路径的长度
def get_path_length(path,path_graph)
    path_array = path.split("-");
    path_length = 0;
    for i in 0..(path_array.length-2) do #遍历到倒数第二个
        if(path_graph[path_array[i].to_sym][path_array[i+1].to_sym] == nil) #如果是空，代表没有路径
            return puts("NO SUCH ROUTE");
	    else
	        path_length += path_graph[path_array[i].to_sym][path_array[i+1].to_sym]; #否则把路径值加进去
	    end
	end
    puts path_length;
end
#测试问题1,2,3,4,5
get_path_length("A-B-C",path_graph)
get_path_length("A-D",path_graph)
get_path_length("A-D-C",path_graph)
get_path_length("A-E-B-C-D",path_graph)
get_path_length("A-E-D",path_graph)

#解决问题7，经过给定次数的车站到达目的地的路径数
def get_num_of_trips_given_stops(start,dest,num_of_stops,path_graph) 
	num_of_trips = 0;
	if(num_of_stops < 1)  #num_of_stops <=0 是异常情况
	    return 0;
	end
	if(num_of_stops == 1)      #这是递归的退出条件
	    if(path_graph[start.to_sym][dest.to_sym] != nil)
	        num_of_trips = 1;
	    else
	        num_of_trips = 0;
	    end
	end
	path_graph[start.to_sym].each do |key,value|
        num_of_trips += get_num_of_trips_given_stops(key,dest,num_of_stops-1,path_graph); #递归A->C经过4个站的路线数等于A的所有下一个站到C经过3个站的路线数之和。
	end
	return num_of_trips;
end

#解决问题6, 最多不超过给定车站数到达目的地的路径数
def get_num_of_trips_max_stops(start,dest,num_of_stops,path_graph) 
    num_of_trips = 0;
    for i in 1..num_of_stops
        num_of_trips += get_num_of_trips_given_stops(start,dest,i,path_graph) #C-C不超过3个站的路径=C->C经过3个站的路径数+ 经过2个站的路径数+经过1个站的路径数
    end
    return num_of_trips;
end
#测试问题6
puts(get_num_of_trips_max_stops("C","C",3,path_graph))
#测试问题7
puts(get_num_of_trips_given_stops("A","C",4,path_graph))


#解决问题8和9,求两点之间的最短路径,如果头尾是同一点则返回的是绕一圈之后的最短路径
def get_shorest_path(start,dest,is_first,path_graph,path) 
	length_of_shorest_path = 0;
    if(start == dest && is_first == false) #如果递归到dest了，说明走通了一条路径，开始向上迭代，
        return 0;
    end
	length_of_shorest_path = Float::INFINITY; #先初始化路径长度为无穷大
	path.push(start) unless (start == dest && is_first==true) #记录下这条路径，便于之后检测回路，例外的是如果一开始起点和终点相等，起点不记录
	
	path_graph[start.to_sym].each do |key,value|
		if(path.include?key.to_s) #如果已经被包含了，说明是回路，直接跳到下一次循环。
		  next;
		else #不然的话，递归进去找最短路径
		    length_of_transit_path = value + get_shorest_path(key.to_s,dest,false,path_graph,path);
		    if(length_of_transit_path < length_of_shorest_path)
		        length_of_shorest_path = length_of_transit_path; #把最短的赋予shorest_path
		    end
		end
	end
	path.pop();
	return length_of_shorest_path;
end
#测试问题8,9
puts(get_shorest_path("B","B",true,path_graph,[]))
puts(get_shorest_path("A","C",true,path_graph,[]))

#解决问题10 求两点间路径长度小于给定长度的路径数量
def get_num_of_trips_less_length(start,dest,length,is_first,path_graph)
    num_of_trips = 0;
    if(length <= 0) #递归退出条件
        return 0;
    end

	if(length > 0)
	    if(start == dest && is_first == false) #首次进入时start==dest 不算一条路径
	        num_of_trips += 1;
	    end
	    path_graph[start.to_sym].each do |key,value|
		num_of_trips += get_num_of_trips_less_length(key.to_s,dest,length-value,false,path_graph);
	    end
	end
	return num_of_trips;
end
#测试问题10
puts(get_num_of_trips_less_length("C","C",30,true,path_graph))
