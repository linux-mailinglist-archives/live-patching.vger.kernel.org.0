Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C50FE8C8C
	for <lists+live-patching@lfdr.de>; Tue, 29 Oct 2019 17:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390252AbfJ2QSB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 29 Oct 2019 12:18:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13484 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389940AbfJ2QSB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 29 Oct 2019 12:18:01 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9TGDfBN114003
        for <live-patching@vger.kernel.org>; Tue, 29 Oct 2019 12:18:00 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vxrru0609-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Tue, 29 Oct 2019 12:18:00 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <live-patching@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Tue, 29 Oct 2019 16:17:58 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 29 Oct 2019 16:17:55 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9TGHJAq29753754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 16:17:19 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36F504C05C;
        Tue, 29 Oct 2019 16:17:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0FFF4C040;
        Tue, 29 Oct 2019 16:17:52 +0000 (GMT)
Received: from osiris (unknown [9.152.212.85])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 29 Oct 2019 16:17:52 +0000 (GMT)
Date:   Tue, 29 Oct 2019 17:17:51 +0100
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     gor@linux.ibm.com, borntraeger@de.ibm.com, jpoimboe@redhat.com,
        joe.lawrence@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, jikos@kernel.org, pmladek@suse.com,
        nstange@suse.de, live-patching@vger.kernel.org
Subject: Re: [PATCH v2 3/3] s390/livepatch: Implement reliable stack tracing
 for the consistency model
References: <20191029143904.24051-1-mbenes@suse.cz>
 <20191029143904.24051-4-mbenes@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029143904.24051-4-mbenes@suse.cz>
X-TM-AS-GCONF: 00
x-cbid: 19102916-0016-0000-0000-000002BED7FB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102916-0017-0000-0000-00003320311E
Message-Id: <20191029161751.GH5646@osiris>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-29_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=640 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910290144
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Miroslav,

> +bool unwind_next_frame_reliable(struct unwind_state *state)
> +{
...
> +}
> +
>  void __unwind_start(struct unwind_state *state, struct task_struct *task,
>  		    struct pt_regs *regs, unsigned long sp,
>  		    bool unwind_reliable)

Did you send the wrong version of your patch series? This patch does
not integrate your new function into the existing one. Also the new
parameter you added with the second patch isn't used at all.

