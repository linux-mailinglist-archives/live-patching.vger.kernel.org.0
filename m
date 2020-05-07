Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72341C95DD
	for <lists+live-patching@lfdr.de>; Thu,  7 May 2020 18:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgEGQCX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 7 May 2020 12:02:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32942 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726029AbgEGQCX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 7 May 2020 12:02:23 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 047G125h092262;
        Thu, 7 May 2020 12:02:06 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s4gx89nu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 May 2020 12:02:03 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 047FVgvZ092738;
        Thu, 7 May 2020 12:01:59 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s4gx89ex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 May 2020 12:01:59 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 047G0ut7017669;
        Thu, 7 May 2020 16:01:48 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 30s0g5upmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 May 2020 16:01:48 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 047G1kEX66781672
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 May 2020 16:01:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3144D42041;
        Thu,  7 May 2020 16:01:46 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D10E84204D;
        Thu,  7 May 2020 16:01:45 +0000 (GMT)
Received: from thinkpad (unknown [9.145.19.24])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 May 2020 16:01:45 +0000 (GMT)
Date:   Thu, 7 May 2020 18:01:44 +0200
From:   Gerald Schaefer <gerald.schaefer@de.ibm.com>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH v4 05/11] s390: Change s390_kernel_write() return type
 to match memcpy()
Message-ID: <20200507180144.165a6edf@thinkpad>
In-Reply-To: <nycvar.YFH.7.76.2005071534170.25812@cbobk.fhfr.pm>
References: <cover.1588173720.git.jpoimboe@redhat.com>
        <be5119b30920d2da6fca3f6d2b1aca5712a2fd30.1588173720.git.jpoimboe@redhat.com>
        <nycvar.YFH.7.76.2005071534170.25812@cbobk.fhfr.pm>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_09:2020-05-07,2020-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070123
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 7 May 2020 15:36:48 +0200 (CEST)
Jiri Kosina <jikos@kernel.org> wrote:

> On Wed, 29 Apr 2020, Josh Poimboeuf wrote:
> 
> > s390_kernel_write()'s function type is almost identical to memcpy().
> > Change its return type to "void *" so they can be used interchangeably.
> > 
> > Cc: linux-s390@vger.kernel.org
> > Cc: heiko.carstens@de.ibm.com
> > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
> > Acked-by: Miroslav Benes <mbenes@suse.cz>
> 
> Also for this one -- s390 folks, could you please provide your Ack for 
> taking things through livepatching.git as part of this series?
> 
> Thanks.
> 

Ah, forgot about that one, sorry. Also looks good.

Acked-by: Gerald Schaefer <gerald.schaefer@de.ibm.com> # s390
