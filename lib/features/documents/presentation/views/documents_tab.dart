// features/documents_list/presentation/views/documents_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scaner_test_task/core/widgets/logo_widget.dart';
import 'package:scaner_test_task/features/documents/presentation/cubit/documents_cubit.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/assets.dart';
import '../../data/models/document.dart';

class DocumentsTab extends StatelessWidget {
  const DocumentsTab({super.key});

  Widget _buildContent(DocumentsState state) {
    if (state is DocumentsLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (state is DocumentsLoaded) {
      return state.documents.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.filteredDocuments.length,
              separatorBuilder: (_, __) => SizedBox(height: 12),
              itemBuilder: (context, index) => DocumentCard(
                document: state.filteredDocuments[index],
              ),
            );
    }

    if (state is DocumentsError) {
      return Center(child: Text('Error: ${state.message}'));
    }

    return _buildEmptyState();
    // return SizedBox.shrink();
  }

  Widget _buildEmptyState() {
    return Image.asset(
      AppImageAssets.nothing.asset,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentsCubit, DocumentsState>(
      builder: (context, state) {
        return Column(
          children: [
            // Logo
            LogoWidget(
              signFontSize: 30.0,
              itFontSize: 30.0,
            ),

            // Search
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchWidget(
                onChanged: (query) =>
                    context.read<DocumentsCubit>().searchDocuments(query),
              ),
            ),

            // Document List
            Expanded(
              child: _buildContent(state),
            ),
          ],
        );
      },
    );
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key, required this.onChanged});
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(34.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.25),
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search,
            weight: 1,
            color: Colors.black.withOpacity(0.25),
          ),
          filled: true,
          fillColor: Color(0xFFFFFFFF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(34.0),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class DocumentCard extends StatelessWidget {
  const DocumentCard({super.key, required this.document});
  final Document document;

  void _showDocumentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Rename'),
            onTap: () {/* Реализация переименования */},
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share'),
            onTap: () {/* Реализация шаринга */},
          ),
          // ListTile(
          //   leading: Icon(Icons.delete),
          //   title: Text('Delete'),
          //   onTap: () =>
          //       context.read<DocumentsCubit>().deleteDocument(document.id),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Icon(Icons.description, color: Color(0xFF364EFF)),
        title: Text(
          document.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          DateFormat('EEE, MMM d, y').format(document.createdAt),
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Icon(Icons.more_vert),
        onTap: () => _showDocumentOptions(context),
      ),
    );
  }
}
