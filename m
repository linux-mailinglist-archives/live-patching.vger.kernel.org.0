Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2535DE8CD0
	for <lists+live-patching@lfdr.de>; Tue, 29 Oct 2019 17:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390192AbfJ2QfC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 29 Oct 2019 12:35:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42732 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390473AbfJ2QfB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 29 Oct 2019 12:35:01 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9TGN7tK141714
        for <live-patching@vger.kernel.org>; Tue, 29 Oct 2019 12:35:00 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vxpb4yv11-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Tue, 29 Oct 2019 12:35:00 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <live-patching@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Tue, 29 Oct 2019 16:34:57 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 29 Oct 2019 16:34:53 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9TGYquB44433852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 16:34:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B77FA4051;
        Tue, 29 Oct 2019 16:34:52 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD884A4040;
        Tue, 29 Oct 2019 16:34:51 +0000 (GMT)
Received: from osiris (unknown [9.152.212.85])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 29 Oct 2019 16:34:51 +0000 (GMT)
Date:   Tue, 29 Oct 2019 17:34:50 +0100
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     gor@linux.ibm.com, borntraeger@de.ibm.com, jpoimboe@redhat.com,
        joe.lawrence@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, jikos@kernel.org, pmladek@suse.com,
        nstange@suse.de, live-patching@vger.kernel.org
Subject: Re: [PATCH v2 0/3] s390/livepatch: Implement reliable stack tracing
 for the consistency model
References: <20191029143904.24051-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029143904.24051-1-mbenes@suse.cz>
X-TM-AS-GCONF: 00
x-cbid: 19102916-0016-0000-0000-000002BED94E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102916-0017-0000-0000-000033203281
Message-Id: <20191029163450.GI5646@osiris>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-29_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=458 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910290145
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Oct 29, 2019 at 03:39:01PM +0100, Miroslav Benes wrote:
> - I tried to use the existing infrastructure as much as possible with
>   one exception. I kept unwind_next_frame_reliable() next to the
>   ordinary unwind_next_frame(). I did not come up with a nice solution
>   how to integrate it. The reliable unwinding is executed on a task
>   stack only, which leads to a nice simplification. My integration
>   attempts only obfuscated the existing unwind_next_frame() which is
>   already not easy to read. Ideas are definitely welcome.

Ah, now I see. So patch 2 seems to be leftover(?). Could you just send
how the result would look like?

I'd really like to have only one function, since some of the sanity
checks you added also make sense for what we already have - so code
would diverge from the beginning.

