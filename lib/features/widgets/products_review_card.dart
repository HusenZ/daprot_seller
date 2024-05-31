import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daprot_seller/domain/model/user_model.dart';
import 'package:daprot_seller/domain/order_repo.dart';
import 'package:daprot_seller/domain/shop_data_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ProductReviewCard extends StatefulWidget {
  const ProductReviewCard({super.key});

  @override
  State<ProductReviewCard> createState() => _ProductReviewCardState();
}

class _ProductReviewCardState extends State<ProductReviewCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QuerySnapshot<Map<String, dynamic>>>>(
      stream: ProductStream().getProductReviewsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorWidget(
              context, 'An error occurred. Please try again later.');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget();
        }

        final reviews = snapshot.data ?? [];

        if (reviews.isEmpty) {
          return _buildEmptyWidget(context, 'No reviews available.');
        }

        return ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final productsRreveiw = reviews[index].docs;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: productsRreveiw.map((reviewDoc) {
                return _buildReviewCard(context, reviewDoc);
              }).toList(),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEmptyWidget(BuildContext context, String message) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context,
      QueryDocumentSnapshot<Map<String, dynamic>> reviewDoc) {
    final reviewText = reviewDoc.get('review');
    final rating = reviewDoc.get('rating');
    final timestamp = reviewDoc.get('timestamp');

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.sp),
      child: ListTile(
        title: StreamBuilder<UserModel>(
          stream: OrderRepository().streamUser(reviewDoc.get('userID')),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text(
                    snapshot.data!.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600),
                  )
                ],
              );
            } else {
              return SizedBox(
                width: 20.w,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 16.0,
                    color: Colors.grey[200],
                  ),
                ),
              );
            }
          },
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '$rating/5.0',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8.sp),
                RatingBarIndicator(
                  rating: rating.toDouble(),
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 24.0,
                  unratedColor: Colors.grey[300]!,
                  direction: Axis.horizontal,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.sp),
              child: Text(
                reviewText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            SizedBox(height: 4.sp),
            Text(
              'Posted on ${DateFormat.yMMMd().add_jm().format(timestamp.toDate())}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
