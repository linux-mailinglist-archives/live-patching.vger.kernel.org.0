Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 657CF15709
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2019 02:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbfEGAn0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 May 2019 20:43:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42478 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbfEGAnZ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 May 2019 20:43:25 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B6E87C007344;
        Tue,  7 May 2019 00:43:25 +0000 (UTC)
Received: from treble (ovpn-123-166.rdu2.redhat.com [10.10.123.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E2DC87E572;
        Tue,  7 May 2019 00:43:21 +0000 (UTC)
Date:   Mon, 6 May 2019 19:43:19 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] livepatch: Use static buffer for debugging
 messages under rq lock
Message-ID: <20190507004319.oxxncicid6pxg352@treble>
References: <20190430091049.30413-1-pmladek@suse.com>
 <20190430091049.30413-3-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190430091049.30413-3-pmladek@suse.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 07 May 2019 00:43:25 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 30, 2019 at 11:10:49AM +0200, Petr Mladek wrote:
> klp_try_switch_task() is called under klp_mutex. The buffer for
> debugging messages might be static.

The patch description is missing a "why" (presumably to reduce stack
usage).

> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> ---
>  kernel/livepatch/transition.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index 8e0274075e75..d66086fd6d75 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -304,11 +304,11 @@ static int klp_check_stack(struct task_struct *task, char *err_buf)
>   */
>  static bool klp_try_switch_task(struct task_struct *task)
>  {
> +	static char err_buf[STACK_ERR_BUF_SIZE];
>  	struct rq *rq;
>  	struct rq_flags flags;
>  	int ret;
>  	bool success = false;
> -	char err_buf[STACK_ERR_BUF_SIZE];
>  
>  	err_buf[0] = '\0';
>  
> @@ -351,7 +351,6 @@ static bool klp_try_switch_task(struct task_struct *task)
>  		pr_debug("%s", err_buf);
>  
>  	return success;
> -
>  }
>  
>  /*
> -- 
> 2.16.4
> 

-- 
Josh
