Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9963ED87B5
	for <lists+live-patching@lfdr.de>; Wed, 16 Oct 2019 07:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbfJPFCb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Oct 2019 01:02:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38300 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727006AbfJPFCb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Oct 2019 01:02:31 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9G51mqw024445
        for <live-patching@vger.kernel.org>; Wed, 16 Oct 2019 01:02:30 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vnva9rn5b-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Wed, 16 Oct 2019 01:02:29 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <live-patching@vger.kernel.org> from <kamalesh@linux.vnet.ibm.com>;
        Wed, 16 Oct 2019 06:02:28 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 16 Oct 2019 06:02:24 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9G52N2435061802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Oct 2019 05:02:23 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA45CA4051;
        Wed, 16 Oct 2019 05:02:22 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E53EA404D;
        Wed, 16 Oct 2019 05:02:21 +0000 (GMT)
Received: from JAVRIS.in.ibm.com (unknown [9.124.35.18])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 16 Oct 2019 05:02:21 +0000 (GMT)
Subject: Re: [PATCH v2] ftrace: Introduce PERMANENT ftrace_ops flag
To:     Miroslav Benes <mbenes@suse.cz>, rostedt@goodmis.org,
        mingo@redhat.com, jpoimboe@redhat.com, jikos@kernel.org,
        pmladek@suse.com, joe.lawrence@redhat.com
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
References: <20191014105923.29607-1-mbenes@suse.cz>
From:   Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date:   Wed, 16 Oct 2019 10:32:20 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191014105923.29607-1-mbenes@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19101605-4275-0000-0000-000003727708
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101605-4276-0000-0000-000038858AF1
Message-Id: <a39036e1-5235-9b5a-f847-12878538781e@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-16_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910160046
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 10/14/19 4:29 PM, Miroslav Benes wrote:
> Livepatch uses ftrace for redirection to new patched functions. It means
> that if ftrace is disabled, all live patched functions are disabled as
> well. Toggling global 'ftrace_enabled' sysctl thus affect it directly.
> It is not a problem per se, because only administrator can set sysctl
> values, but it still may be surprising.
> 
> Introduce PERMANENT ftrace_ops flag to amend this. If the
> FTRACE_OPS_FL_PERMANENT is set on any ftrace ops, the tracing cannot be
> disabled by disabling ftrace_enabled. Equally, a callback with the flag
> set cannot be registered if ftrace_enabled is disabled.
> 
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>

The patch looks good to me. A minor typo in flag description below.

Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

[...]
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 8a8cb3c401b2..c2cad29dc557 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -142,6 +142,8 @@ ftrace_func_t ftrace_ops_get_func(struct ftrace_ops *ops);
>   * PID     - Is affected by set_ftrace_pid (allows filtering on those pids)
>   * RCU     - Set when the ops can only be called when RCU is watching.
>   * TRACE_ARRAY - The ops->private points to a trace_array descriptor.
> + * PERMAMENT - Set when the ops is permanent and should not be affected by
> + *             ftrace_enabled.
>   */

s/PERMAMENT/PERMANENT

> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 62a50bf399d6..d2992ea29fe1 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -6752,12 +6764,19 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
>  		ftrace_startup_sysctl();
> 
>  	} else {
> +		if (is_permanent_ops_registered()) {
> +			ftrace_enabled = last_ftrace_enabled;
> +			ret = -EBUSY;
> +			goto out;
> +		}
> +
>  		/* stopping ftrace calls (just send to ftrace_stub) */
>  		ftrace_trace_function = ftrace_stub;
> 
>  		ftrace_shutdown_sysctl();
>  	}
> 
> +	last_ftrace_enabled = !!ftrace_enabled;

No strong feelings on last_ftrace_enabled placement, leaving it to
your preference. 

>   out:
>  	mutex_unlock(&ftrace_lock);
>  	return ret;
> 


-- 
Kamalesh

