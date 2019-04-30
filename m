Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75F9CF8E0
	for <lists+live-patching@lfdr.de>; Tue, 30 Apr 2019 14:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfD3MaT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Apr 2019 08:30:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42352 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726123AbfD3MaS (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Apr 2019 08:30:18 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3UCMC34145878
        for <live-patching@vger.kernel.org>; Tue, 30 Apr 2019 08:30:17 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s6p27hbkd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Tue, 30 Apr 2019 08:30:17 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <live-patching@vger.kernel.org> from <kamalesh@linux.vnet.ibm.com>;
        Tue, 30 Apr 2019 13:30:15 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 30 Apr 2019 13:30:11 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3UCUAk751314936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Apr 2019 12:30:10 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52C8FAE055;
        Tue, 30 Apr 2019 12:30:10 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CC16AE053;
        Tue, 30 Apr 2019 12:30:08 +0000 (GMT)
Received: from JAVRIS.in.ibm.com (unknown [9.85.97.254])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 30 Apr 2019 12:30:08 +0000 (GMT)
Date:   Tue, 30 Apr 2019 18:00:05 +0530
From:   Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] livepatch: Use static buffer for debugging
 messages under rq lock
References: <20190430091049.30413-1-pmladek@suse.com>
 <20190430091049.30413-3-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430091049.30413-3-pmladek@suse.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-TM-AS-GCONF: 00
x-cbid: 19043012-0012-0000-0000-00000316DAF1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19043012-0013-0000-0000-0000214F43D1
Message-Id: <20190430123005.GB18595@JAVRIS.in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-30_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=744 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904300081
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 30, 2019 at 11:10:49AM +0200, Petr Mladek wrote:
> klp_try_switch_task() is called under klp_mutex. The buffer for
> debugging messages might be static.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>

Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

