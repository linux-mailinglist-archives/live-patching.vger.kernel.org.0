Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9F7132797
	for <lists+live-patching@lfdr.de>; Tue,  7 Jan 2020 14:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgAGN3l (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 Jan 2020 08:29:41 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59548 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbgAGN3l (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 Jan 2020 08:29:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007DTbMv111132;
        Tue, 7 Jan 2020 13:29:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=0ae2azomCU9DeDU7MGXQXZWjRffWWuG+1zMzBWYFy/M=;
 b=BW0Ici4lxH/11jBJjem69XbqTua1jlXfEruSxmvhrSM3Hw6F1fCSRqIYgj31eeIBALHW
 Yl4xfKfhMCo6XjBqOBHQ7zYLVj6m9w6EQh1AO4epojyp32iohi1nvtgc7LjcF6vSwbqk
 4e0dM/k0hnnW7BGDCqK0zWIJKUoP4Ijnipb4pYh/VXwAk/xJgqcwVe6xZyYjLyo+/v/F
 GAnHQmxnYYHhDw+PXpVg2P1Mpbn07mDwrColRWc1gLBF77LHLcuDtVsMcCqsbtvw8QBU
 NVpKMjGE8H1U1hTEUVgZS5oHR/CqkIDScrsQ4l8KtiZNQXgELpf6vj55cs0nTFoSu15J rA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xajnpweme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 13:29:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007DSZPe080083;
        Tue, 7 Jan 2020 13:29:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xcpamh5u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 13:29:37 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 007DTaf4024647;
        Tue, 7 Jan 2020 13:29:36 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 05:29:35 -0800
Date:   Tue, 7 Jan 2020 16:29:29 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     pmladek@suse.com
Cc:     live-patching@vger.kernel.org
Subject: [bug report] livepatch: Initialize shadow variables safely by a
 custom callback
Message-ID: <20200107132929.ficffmrm5ntpzcqa@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=431
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001070113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=481 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001070113
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello Petr Mladek,

The patch e91c2518a5d2: "livepatch: Initialize shadow variables
safely by a custom callback" from Apr 16, 2018, leads to the
following static checker warning:

	samples/livepatch/livepatch-shadow-fix1.c:86 livepatch_fix1_dummy_alloc()
	error: 'klp_shadow_alloc()' 'leak' too small (4 vs 8)

samples/livepatch/livepatch-shadow-fix1.c
    53  static int shadow_leak_ctor(void *obj, void *shadow_data, void *ctor_data)
    54  {
    55          void **shadow_leak = shadow_data;
    56          void *leak = ctor_data;
    57  
    58          *shadow_leak = leak;
    59          return 0;
    60  }
    61  
    62  static struct dummy *livepatch_fix1_dummy_alloc(void)
    63  {
    64          struct dummy *d;
    65          void *leak;
    66  
    67          d = kzalloc(sizeof(*d), GFP_KERNEL);
    68          if (!d)
    69                  return NULL;
    70  
    71          d->jiffies_expire = jiffies +
    72                  msecs_to_jiffies(1000 * EXPIRE_PERIOD);
    73  
    74          /*
    75           * Patch: save the extra memory location into a SV_LEAK shadow
    76           * variable.  A patched dummy_free routine can later fetch this
    77           * pointer to handle resource release.
    78           */
    79          leak = kzalloc(sizeof(int), GFP_KERNEL);
    80          if (!leak) {
    81                  kfree(d);
    82                  return NULL;
    83          }
    84  
    85          klp_shadow_alloc(d, SV_LEAK, sizeof(leak), GFP_KERNEL,
                                             ^^^^^^^^^^^^
This doesn't seem right at all?  Leak is a pointer.  Why is leak a void
pointer instead of an int pointer?

    86                           shadow_leak_ctor, leak);
    87  
    88          pr_info("%s: dummy @ %p, expires @ %lx\n",
    89                  __func__, d, d->jiffies_expire);
    90  
    91          return d;
    92  }

regards,
dan carpenter
