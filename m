Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F22922392
	for <lists+live-patching@lfdr.de>; Sat, 18 May 2019 15:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbfERNwY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 18 May 2019 09:52:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36932 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728037AbfERNwY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 18 May 2019 09:52:24 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4IDpV8x166247
        for <live-patching@vger.kernel.org>; Sat, 18 May 2019 09:52:23 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sjbns3t86-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Sat, 18 May 2019 09:52:22 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <live-patching@vger.kernel.org> from <kamalesh@linux.vnet.ibm.com>;
        Sat, 18 May 2019 14:52:21 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 18 May 2019 14:52:16 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4IDqFpp37814272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 May 2019 13:52:15 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9741A4054;
        Sat, 18 May 2019 13:52:15 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24114A405B;
        Sat, 18 May 2019 13:52:14 +0000 (GMT)
Received: from JAVRIS.in.ibm.com (unknown [9.199.47.185])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sat, 18 May 2019 13:52:13 +0000 (GMT)
Date:   Sat, 18 May 2019 19:22:11 +0530
From:   Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jikos@kernel.org, jpoimboe@redhat.com, pmladek@suse.com,
        tglx@linutronix.de
Subject: Re: [PATCH] stacktrace: fix CONFIG_ARCH_STACKWALK
 stack_trace_save_tsk_reliable return
References: <20190517185117.24642-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517185117.24642-1-joe.lawrence@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-TM-AS-GCONF: 00
x-cbid: 19051813-0028-0000-0000-0000036F091B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051813-0029-0000-0000-0000242EAA75
Message-Id: <20190518135211.GA17374@JAVRIS.in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-18_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905180099
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, May 17, 2019 at 02:51:17PM -0400, Joe Lawrence wrote:
> Miroslav reported that the livepatch self-tests were failing,
> specifically a case in which the consistency model ensures that we do
> not patch a current executing function, "TEST: busy target module".
> 
> Recent renovations to stack_trace_save_tsk_reliable() left it returning
> only an -ERRNO success indication in some configuration combinations:
> 
>   klp_check_stack()
>     ret = stack_trace_save_tsk_reliable()
>       #ifdef CONFIG_ARCH_STACKWALK && CONFIG_HAVE_RELIABLE_STACKTRACE
>         stack_trace_save_tsk_reliable()
>           ret = arch_stack_walk_reliable()
>             return 0
>             return -EINVAL
>           ...
>           return ret;
>     ...
>     if (ret < 0)
>       /* stack_trace_save_tsk_reliable error */
>     nr_entries = ret;                               << 0
> 
> Previously (and currently for !CONFIG_ARCH_STACKWALK &&
> CONFIG_HAVE_RELIABLE_STACKTRACE) stack_trace_save_tsk_reliable()
> returned the number of entries that it consumed in the passed storage
> array.
> 
> In the case of the above config and trace, be sure to return the
> stacktrace_cookie.len on stack_trace_save_tsk_reliable() success.
> 
> Fixes: 25e39e32b0a3f ("livepatch: Simplify stack trace retrieval")
> Reported-by: Miroslav Benes <mbenes@suse.cz>
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>

Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

