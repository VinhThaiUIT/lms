import 'package:flutter/material.dart';

class PaginatedListView extends StatefulWidget {
  final ScrollController scrollController;
  final Function(int offset) onPaginate;
  final int? totalSize;
  final int? offset;
  final Widget itemView;
  
  const PaginatedListView({
    super.key, required this.scrollController, required this.onPaginate, required this.totalSize,
    required this.offset, required this.itemView,
  });

  @override
  State<PaginatedListView> createState() => _PaginatedListViewState();
}

class _PaginatedListViewState extends State<PaginatedListView> {
  late int _offset;
  List<int>? _offsetList;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _offset = 1;
    _offsetList = [1];
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent
          && widget.totalSize != null && !_isLoading) {
        if(mounted) {
          _paginate();
        }
      }
    });
  }


  void _paginate() async {
    int pageSize = (widget.totalSize! / 10).ceil();
    if (_offset < pageSize && !_offsetList!.contains(_offset+1)) {

      setState(() {
        _offset = _offset + 1;
        _offsetList!.add(_offset);
        _isLoading = true;
      });
      await widget.onPaginate(_offset);
      setState(() {
        _isLoading = false;
      });

    }else {
      if(_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.offset != null) {
      _offset = widget.offset!;
      _offsetList = [];
      for(int index=1; index<=widget.offset!; index++) {
        _offsetList!.add(index);
      }
    }
    return widget.itemView;

  }
}