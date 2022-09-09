Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA765B3EA2
	for <lists+live-patching@lfdr.de>; Fri,  9 Sep 2022 20:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiIISOG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Sep 2022 14:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiIISOE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Sep 2022 14:14:04 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E403E3D50;
        Fri,  9 Sep 2022 11:14:03 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 289HhM0W037006;
        Fri, 9 Sep 2022 18:13:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : subject :
 to : cc : references : in-reply-to : mime-version : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=TMGAj35IXe4Zm5sRpl1s3sEA34Iz+ttSZdHEflkb6FM=;
 b=m/nYtKLkPisCSi8h5i8EcG6koFE+HFt/w1wnzXJMArORHZByzBZ3l6IMnwRZfiQYcHAE
 /3WOa/hs5a7GjL7kizhFXmgfXVFsmFmHac/5mpRVFTFH+nEO79gufKipQOtIyDRutBJx
 Zw0I1BF4Pq1pKbuo0pqVK7UHhDKh7joWgGn8uHlgIUQasgI0GVL5vNQN5tZuz2CHg39Y
 BXKC6YicZMDZoaJSZP9Ibxt6aIR5nSRoZziJMUpF7KyyH9f7in7v3TsIYVnJQC/azzkP
 cr8OhVjDnfhbRI3tJI9ZVYE9Zon0P02TqCcwUababMzBlM06wqunb4vD7iAaCs+yvQOo gw== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jga4kruj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 18:13:46 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 289I5Pas013244;
        Fri, 9 Sep 2022 18:13:44 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3jbxj8x5q0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Sep 2022 18:13:44 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 289IA7JL33620472
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Sep 2022 18:10:07 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 681FF5204F;
        Fri,  9 Sep 2022 18:13:42 +0000 (GMT)
Received: from localhost (unknown [9.43.41.127])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A941E5204E;
        Fri,  9 Sep 2022 18:13:41 +0000 (GMT)
Date:   Fri, 09 Sep 2022 23:43:39 +0530
From:   "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Subject: Re: [PATCH v5 bpf-next 2/4] ftrace: Allow IPMODIFY and DIRECT ops on
 the same function
To:     Song Liu <songliubraving@fb.com>
Cc:     Kernel Team <Kernel-team@fb.com>, bpf <bpf@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Song Liu <song@kernel.org>
References: <20220720002126.803253-1-song@kernel.org>
        <20220720002126.803253-3-song@kernel.org>
        <1662724350.8os86rhyxk.naveen@linux.ibm.com>
        <B59F0FD0-FA3E-4A8B-B588-8F9AA8AC602A@fb.com>
In-Reply-To: <B59F0FD0-FA3E-4A8B-B588-8F9AA8AC602A@fb.com>
MIME-Version: 1.0
User-Agent: astroid/4d6b06ad (https://github.com/astroidmail/astroid)
Message-Id: <1662747146.nqpswjliso.naveen@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QKcrZsRK9tV5Qztkv9R6r6KOhg2rw0Nt
X-Proofpoint-ORIG-GUID: QKcrZsRK9tV5Qztkv9R6r6KOhg2rw0Nt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-09_08,2022-09-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 spamscore=0 priorityscore=1501
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209090064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Song,

Song Liu wrote:
>=20
>=20
>> On Sep 9, 2022, at 4:58 AM, Naveen N. Rao <naveen.n.rao@linux.ibm.com> w=
rote:
>>=20
>> Song Liu wrote:
>=20
> [...]
>=20
>>> +
>>> /**
>>>  * register_ftrace_function - register a function for profiling
>>>  * @ops:	ops structure that holds the function for profiling.
>>> @@ -8018,14 +8206,15 @@ int register_ftrace_function(struct ftrace_ops =
*ops)
>>> {
>>> 	int ret;
>>> -	ftrace_ops_init(ops);
>>> -
>>> -	mutex_lock(&ftrace_lock);
>>> -
>>> -	ret =3D ftrace_startup(ops, 0);
>>> +	lock_direct_mutex();
>>=20
>> Trying to enable ftrace direct on powerpc, this is resulting in a hung t=
ask when testing samples/ftrace/ftrace-direct-modify.c
>>=20
>> Essentially, the sample calls modify_ftrace_direct(), which grabs direct=
_mutex before calling ftrace_modify_direct_caller()->register_ftrace_functi=
on().
>>=20
>=20
> Thanks for the report. Would the following change fix the issue?
>=20
> Song
>=20
> diff --git i/kernel/trace/ftrace.c w/kernel/trace/ftrace.c
> index bc921a3f7ea8..2f1e6cfa834e 100644
> --- i/kernel/trace/ftrace.c
> +++ w/kernel/trace/ftrace.c
> @@ -5496,7 +5496,7 @@ int __weak ftrace_modify_direct_caller(struct ftrac=
e_func_entry *entry,
>         if (ret)
>                 goto out_lock;
>=20
> -       ret =3D register_ftrace_function(&stub_ops);
> +       ret =3D register_ftrace_function_nolock(&stub_ops);
>         if (ret) {
>                 ftrace_set_filter_ip(&stub_ops, ip, 1, 0);
>                 goto out_lock;
>=20

That fixes it for me.
Reported-and-Tested-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>


Thanks!
- Naveen

