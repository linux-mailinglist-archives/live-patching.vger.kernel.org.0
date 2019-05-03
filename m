Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5CCB13226
	for <lists+live-patching@lfdr.de>; Fri,  3 May 2019 18:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfECQ0F (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 May 2019 12:26:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44298 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726720AbfECQ0F (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 May 2019 12:26:05 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x43GBoCZ080547
        for <live-patching@vger.kernel.org>; Fri, 3 May 2019 12:26:04 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2s8rf6hrvf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Fri, 03 May 2019 12:26:03 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <live-patching@vger.kernel.org> from <kamalesh@linux.vnet.ibm.com>;
        Fri, 3 May 2019 17:26:02 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 3 May 2019 17:25:58 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x43GPvEi34144392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 May 2019 16:25:57 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3413AE051;
        Fri,  3 May 2019 16:25:57 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD258AE04D;
        Fri,  3 May 2019 16:25:55 +0000 (GMT)
Received: from JAVRIS.in.ibm.com (unknown [9.85.86.157])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  3 May 2019 16:25:55 +0000 (GMT)
Date:   Fri, 3 May 2019 21:55:52 +0530
From:   Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, live-patching@vger.kernel.org
Subject: Re: [PATCH 2/2] docs/livepatch: Unify style of livepatch
 documentation in the ReST format
References: <20190503143024.28358-1-pmladek@suse.com>
 <20190503143024.28358-3-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503143024.28358-3-pmladek@suse.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-TM-AS-GCONF: 00
x-cbid: 19050316-0012-0000-0000-00000317FEE0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050316-0013-0000-0000-000021507270
Message-Id: <20190503162552.GB14216@JAVRIS.in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-03_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905030104
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, May 03, 2019 at 04:30:24PM +0200, Petr Mladek wrote:
> Make the structure of "Livepatch module Elf format" document similar
> to the main "Livepatch" document.
> 
> Also make the structure of "(Un)patching Callbacks" document similar
> to the "Shadow Variables" document.
> 
> It fixes the most visible inconsistencies of the documentation
> generated from the ReST format.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

-- 
Kamalesh

