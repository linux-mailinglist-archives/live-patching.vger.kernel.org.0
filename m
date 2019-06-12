Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4420342809
	for <lists+live-patching@lfdr.de>; Wed, 12 Jun 2019 15:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439309AbfFLNwf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 12 Jun 2019 09:52:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46548 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436797AbfFLNwf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 12 Jun 2019 09:52:35 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CDh98W018731
        for <live-patching@vger.kernel.org>; Wed, 12 Jun 2019 09:52:35 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t32ff0ppf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Wed, 12 Jun 2019 09:52:34 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <live-patching@vger.kernel.org> from <kamalesh@linux.vnet.ibm.com>;
        Wed, 12 Jun 2019 14:52:32 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 12 Jun 2019 14:52:28 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5CDqROs57868408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 13:52:27 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7935E5205F;
        Wed, 12 Jun 2019 13:52:27 +0000 (GMT)
Received: from JAVRIS.in.ibm.com (unknown [9.85.88.130])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id F09EE52054;
        Wed, 12 Jun 2019 13:52:25 +0000 (GMT)
Date:   Wed, 12 Jun 2019 19:22:23 +0530
From:   Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     jpoimboe@redhat.com, jikos@kernel.org, pmladek@suse.com,
        joe.lawrence@redhat.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/3] livepatch: Remove duplicate warning about missing
 reliable stacktrace support
References: <20190611141320.25359-1-mbenes@suse.cz>
 <20190611141320.25359-4-mbenes@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611141320.25359-4-mbenes@suse.cz>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-TM-AS-GCONF: 00
x-cbid: 19061213-0028-0000-0000-00000379AAEE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061213-0029-0000-0000-000024399FB9
Message-Id: <20190612135223.GC8298@JAVRIS.in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120093
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jun 11, 2019 at 04:13:20PM +0200, Miroslav Benes wrote:
> From: Petr Mladek <pmladek@suse.com>
> 
> WARN_ON_ONCE() could not be called safely under rq lock because
> of console deadlock issues. Moreover WARN_ON_ONCE() is superfluous in
> klp_check_stack(), because stack_trace_save_tsk_reliable() cannot return
> -ENOSYS thanks to klp_have_reliable_stack() check in
> klp_try_switch_task().
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> [ mbenes: changelog edited ]
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>

Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

