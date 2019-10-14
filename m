Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED59D6601
	for <lists+live-patching@lfdr.de>; Mon, 14 Oct 2019 17:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387444AbfJNPRW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 14 Oct 2019 11:17:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732397AbfJNPRW (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 14 Oct 2019 11:17:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BAC120854;
        Mon, 14 Oct 2019 15:17:21 +0000 (UTC)
Date:   Mon, 14 Oct 2019 11:17:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     mingo@redhat.com, jpoimboe@redhat.com, jikos@kernel.org,
        pmladek@suse.com, joe.lawrence@redhat.com,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH v2] ftrace: Introduce PERMANENT ftrace_ops flag
Message-ID: <20191014111719.141bd4fa@gandalf.local.home>
In-Reply-To: <20191014105923.29607-1-mbenes@suse.cz>
References: <20191014105923.29607-1-mbenes@suse.cz>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 14 Oct 2019 12:59:23 +0200
Miroslav Benes <mbenes@suse.cz> wrote:

>  int
>  ftrace_enable_sysctl(struct ctl_table *table, int write,
>  		     void __user *buffer, size_t *lenp,
> @@ -6740,8 +6754,6 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
>  	if (ret || !write || (last_ftrace_enabled == !!ftrace_enabled))
>  		goto out;
>  
> -	last_ftrace_enabled = !!ftrace_enabled;
> -
>  	if (ftrace_enabled) {
>  
>  		/* we are starting ftrace again */
> @@ -6752,12 +6764,19 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
>  		ftrace_startup_sysctl();
>  
>  	} else {
> +		if (is_permanent_ops_registered()) {
> +			ftrace_enabled = last_ftrace_enabled;

Although this is not incorrect, but may be somewhat confusing.

At this location, last_ftrace_enabled is always true.

I'm thinking this would be better to simply set it to false here.


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
>   out:

And move the assignment of last_ftrace_enabled to after the "out:"
label.

-- Steve

>  	mutex_unlock(&ftrace_lock);
>  	return ret;

