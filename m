Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4E613249
	for <lists+live-patching@lfdr.de>; Fri,  3 May 2019 18:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbfECQfP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 May 2019 12:35:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38008 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726376AbfECQfP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 May 2019 12:35:15 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x43GX5JH018878
        for <live-patching@vger.kernel.org>; Fri, 3 May 2019 12:35:13 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s8qjjvdf5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Fri, 03 May 2019 12:35:13 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <live-patching@vger.kernel.org> from <kamalesh@linux.vnet.ibm.com>;
        Fri, 3 May 2019 17:35:11 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 3 May 2019 17:35:07 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x43GZ62q42008720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 May 2019 16:35:06 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03B2152050;
        Fri,  3 May 2019 16:35:06 +0000 (GMT)
Received: from JAVRIS.in.ibm.com (unknown [9.85.86.157])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id AF2475204E;
        Fri,  3 May 2019 16:35:03 +0000 (GMT)
Date:   Fri, 3 May 2019 22:05:00 +0530
From:   Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        "Tobin C . Harding" <tobin@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] livepatch: Remove custom kobject state handling
References: <20190503132625.23442-1-pmladek@suse.com>
 <20190503132625.23442-2-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503132625.23442-2-pmladek@suse.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-TM-AS-GCONF: 00
x-cbid: 19050316-0016-0000-0000-00000278039C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050316-0017-0000-0000-000032D4A186
Message-Id: <20190503163500.GC14216@JAVRIS.in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-03_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905030106
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, May 03, 2019 at 03:26:24PM +0200, Petr Mladek wrote:
> kobject_init() always succeeds and sets the reference count to 1.
> It allows to always free the structures via kobject_put() and
> the related release callback.
> 
> Note that the custom kobject state handling was used only
> because we did not know that kobject_put() can and actually
> should get called even when kobject_init_and_add() fails.
> 
> The patch should not change the existing behavior.
> 
> Suggested-by: "Tobin C. Harding" <tobin@kernel.org>
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> ---
>  include/linux/livepatch.h |  3 ---
>  kernel/livepatch/core.c   | 56 ++++++++++++++---------------------------------
>  2 files changed, 17 insertions(+), 42 deletions(-)
> 
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 53551f470722..a14bab1a0a3e 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -86,7 +86,6 @@ struct klp_func {
>  	struct list_head node;
>  	struct list_head stack_node;
>  	unsigned long old_size, new_size;
> -	bool kobj_added;
>  	bool nop;
>  	bool patched;
>  	bool transition;

Minor nitpick, the description of kobj_added needs to be removed from
structure descriptions. 

Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

-- 
Kamalesh

