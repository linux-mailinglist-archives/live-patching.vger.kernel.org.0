Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D9E3C1421
	for <lists+live-patching@lfdr.de>; Thu,  8 Jul 2021 15:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhGHNWW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 8 Jul 2021 09:22:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62224 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230254AbhGHNWW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 8 Jul 2021 09:22:22 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 168D3Rc4089316;
        Thu, 8 Jul 2021 09:19:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=a6ht9fWcftbDkY/phtJSvy+Xk8N90i08AhnE9h0GppI=;
 b=d7l5jf2+soU8x5cVsHPm7dAMvaArXX6pc+8EcXWymu1wXxT7jes347l48KQSjs7Xbj7p
 T4ctt8xuP9J1Ur625X6oeBR7wQXTAzdd9vvxiqac1OjJw+WpwyxnZl/D2rrVRCpEJwnv
 QefvH3J4NQBVCK2oH5NosWesbrsTGvi7ultTLyMWig5VNFiG5dxc2g5qzg0mJ+Ckbn7v
 ST+cSXEwQpZmEiF+lLlkXK6THqYqoztLjTqXU7hImAeWE6ll99KxRj/YP9etf+bafCil
 2kOm3FYvMhyaqWiFvHv817dL/NjLq9oPq0/XIODGAo3Ga7FHJT2amm0x2EuMdSEDKh1K ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39nvwktgb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Jul 2021 09:19:33 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 168D4LnT096113;
        Thu, 8 Jul 2021 09:19:33 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39nvwktg9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Jul 2021 09:19:32 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 168DI163032626;
        Thu, 8 Jul 2021 13:19:30 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 39jf5ha7mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Jul 2021 13:19:30 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 168DJR3i32571902
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Jul 2021 13:19:27 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B78AA405C;
        Thu,  8 Jul 2021 13:19:27 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED4E5A4064;
        Thu,  8 Jul 2021 13:19:26 +0000 (GMT)
Received: from localhost (unknown [9.145.63.161])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  8 Jul 2021 13:19:26 +0000 (GMT)
Date:   Thu, 8 Jul 2021 15:19:25 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] livepatch: Speed up transition retries
Message-ID: <your-ad-here.call-01625750365-ext-6037@work.hours>
References: <patch.git-3127eb42c636.your-ad-here.call-01625661963-ext-4010@work.hours>
 <YObU7HQ1vUAQzME3@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YObU7HQ1vUAQzME3@alley>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lxzj2KDpD46u5wge5zXY5J3QylFjfmNy
X-Proofpoint-ORIG-GUID: NCshRIEWHdJVf9H4EktqHfA6qhl1xzke
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-08_06:2021-07-08,2021-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2107080073
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jul 08, 2021 at 12:35:24PM +0200, Petr Mladek wrote:
> On Wed 2021-07-07 14:49:41, Vasily Gorbik wrote:
> > That's just a racy hack for now for demonstration purposes.
> > 
> > For s390 LPAR with 128 cpu this reduces livepatch kselftest run time
> > from
> > real    1m11.837s
> > user    0m0.603s
> > sys     0m10.940s
> > 
> > to
> > real    0m14.550s
> > user    0m0.420s
> > sys     0m5.779s
> > 
> > Would smth like that be useful for production use cases?
> > Any ideas how to approach that more gracefully?
> 
> Honestly, I do not see a real life use case for this, except maybe
> speeding up a test suite.
> 
> The livepatch transition is more about reliability than about speed.
> In the real life, a livepatch will be applied only once in a while.

That's what I thought. Thanks for looking. Dropping this one.
