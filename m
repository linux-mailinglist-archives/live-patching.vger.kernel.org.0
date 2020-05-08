Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3DAA1CB1E0
	for <lists+live-patching@lfdr.de>; Fri,  8 May 2020 16:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgEHOfe (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 8 May 2020 10:35:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25074 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726689AbgEHOfe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 8 May 2020 10:35:34 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 048EXXkv017242;
        Fri, 8 May 2020 10:35:21 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30vtt3xrya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 10:35:20 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 048EZ4fa021283;
        Fri, 8 May 2020 10:35:04 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30vtt3xrxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 10:35:04 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 048EV34h021377;
        Fri, 8 May 2020 14:35:02 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 30s0g5wjdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 14:35:02 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 048EZ09764159894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 May 2020 14:35:00 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C2934203F;
        Fri,  8 May 2020 14:35:00 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6476F42042;
        Fri,  8 May 2020 14:34:58 +0000 (GMT)
Received: from JAVRIS.in.ibm.com (unknown [9.79.188.133])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  8 May 2020 14:34:58 +0000 (GMT)
Subject: Re: [PATCH -next] livepatch: Make klp_apply_object_relocs static
To:     Samuel Zou <zou_wei@huawei.com>, jpoimboe@redhat.com,
        jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
        joe.lawrence@redhat.com
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1588939594-58255-1-git-send-email-zou_wei@huawei.com>
From:   Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Message-ID: <452d206f-4d4f-747f-be34-76fc3c09f780@linux.vnet.ibm.com>
Date:   Fri, 8 May 2020 20:04:56 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1588939594-58255-1-git-send-email-zou_wei@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_14:2020-05-08,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 spamscore=0 clxscore=1011 priorityscore=1501 suspectscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080130
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 5/8/20 5:36 PM, Samuel Zou wrote:
> Fix the following sparse warning:
> 
> kernel/livepatch/core.c:748:5: warning: symbol 'klp_apply_object_relocs'
> was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Samuel Zou <zou_wei@huawei.com>

LGTM, klp_apply_object_relocs() has only one call site within core.c

Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

> ---
>  kernel/livepatch/core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 96d2da1..f76fdb9 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -745,7 +745,8 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
>  			   func->old_sympos ? func->old_sympos : 1);
>  }
> 
> -int klp_apply_object_relocs(struct klp_patch *patch, struct klp_object *obj)
> +static int klp_apply_object_relocs(struct klp_patch *patch,
> +				   struct klp_object *obj)
>  {
>  	int i, ret;
>  	struct klp_modinfo *info = patch->mod->klp_info;
> 


