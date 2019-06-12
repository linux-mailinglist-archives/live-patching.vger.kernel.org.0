Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7512427D7
	for <lists+live-patching@lfdr.de>; Wed, 12 Jun 2019 15:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408480AbfFLNlb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 12 Jun 2019 09:41:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43286 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2408463AbfFLNla (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 12 Jun 2019 09:41:30 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CDKJvd184974
        for <live-patching@vger.kernel.org>; Wed, 12 Jun 2019 09:41:29 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t31fd3bpr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Wed, 12 Jun 2019 09:41:29 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <live-patching@vger.kernel.org> from <kamalesh@linux.vnet.ibm.com>;
        Wed, 12 Jun 2019 14:41:27 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 12 Jun 2019 14:41:23 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5CDfMk259441320
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 13:41:22 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 164AD5204E;
        Wed, 12 Jun 2019 13:41:22 +0000 (GMT)
Received: from JAVRIS.in.ibm.com (unknown [9.85.88.130])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 2C2DB52054;
        Wed, 12 Jun 2019 13:41:18 +0000 (GMT)
Date:   Wed, 12 Jun 2019 19:11:15 +0530
From:   Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     jpoimboe@redhat.com, jikos@kernel.org, pmladek@suse.com,
        joe.lawrence@redhat.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4 1/3] stacktrace: Remove weak version of
 save_stack_trace_tsk_reliable()
References: <20190611141320.25359-1-mbenes@suse.cz>
 <20190611141320.25359-2-mbenes@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611141320.25359-2-mbenes@suse.cz>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-TM-AS-GCONF: 00
x-cbid: 19061213-0012-0000-0000-000003288037
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061213-0013-0000-0000-000021618832
Message-Id: <20190612134115.GA8298@JAVRIS.in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=861 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120092
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jun 11, 2019 at 04:13:18PM +0200, Miroslav Benes wrote:
> Recent rework of stack trace infrastructure introduced a new set of
> helpers for common stack trace operations (commit e9b98e162aa5
> ("stacktrace: Provide helpers for common stack trace operations") and
> related). As a result, save_stack_trace_tsk_reliable() is not directly
> called anywhere. Livepatch, currently the only user of the reliable
> stack trace feature, now calls stack_trace_save_tsk_reliable().
> 
> When CONFIG_HAVE_RELIABLE_STACKTRACE is set and depending on
> CONFIG_ARCH_STACKWALK, stack_trace_save_tsk_reliable() calls either
> arch_stack_walk_reliable() or mentioned save_stack_trace_tsk_reliable().
> x86_64 defines the former, ppc64le the latter. All other architectures
> do not have HAVE_RELIABLE_STACKTRACE and include/linux/stacktrace.h
> defines -ENOSYS returning version for them.
> 
> In short, stack_trace_save_tsk_reliable() returning -ENOSYS defined in
> include/linux/stacktrace.h serves the same purpose as the old weak
> version of save_stack_trace_tsk_reliable() which is therefore no longer
> needed.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>

Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

