Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E90447220
	for <lists+live-patching@lfdr.de>; Sat, 15 Jun 2019 22:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725535AbfFOUnb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 15 Jun 2019 16:43:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43226 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726857AbfFOUnb (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Sat, 15 Jun 2019 16:43:31 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 108A13083391;
        Sat, 15 Jun 2019 20:43:31 +0000 (UTC)
Received: from treble (ovpn-112-16.rdu2.redhat.com [10.10.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 044F660CA3;
        Sat, 15 Jun 2019 20:43:24 +0000 (UTC)
Date:   Sat, 15 Jun 2019 15:43:20 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com,
        kamalesh@linux.vnet.ibm.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4 0/3] livepatch: Cleanup of reliable stacktrace warnings
Message-ID: <20190615204320.i4qxbk2m3ee73vyg@treble>
References: <20190611141320.25359-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190611141320.25359-1-mbenes@suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Sat, 15 Jun 2019 20:43:31 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jun 11, 2019 at 04:13:17PM +0200, Miroslav Benes wrote:
> This is the fourth attempt to improve the situation of reliable stack
> trace warnings in livepatch. Based on discussion in
> 20190531074147.27616-1-pmladek@suse.com (v3).
> 
> Changes against v3:
> + weak save_stack_trace_tsk_reliable() removed, because it is not needed
>   anymore thanks to Thomas' recent improvements
> + klp_have_reliable_stack() check reintroduced in klp_try_switch_task()
> 
> Changes against v2:
> 
> + Put back the patch removing WARN_ONCE in the weak
>   save_stack_trace_tsk_reliable(). It is related.
> + Simplified patch removing the duplicate warning from klp_check_stack()
> + Update commit message for 3rd patch [Josh]
> 
> Miroslav Benes (2):
>   stacktrace: Remove weak version of save_stack_trace_tsk_reliable()
>   Revert "livepatch: Remove reliable stacktrace check in
>     klp_try_switch_task()"
> 
> Petr Mladek (1):
>   livepatch: Remove duplicate warning about missing reliable stacktrace
>     support
> 
>  kernel/livepatch/transition.c | 8 +++++++-
>  kernel/stacktrace.c           | 8 --------
>  2 files changed, 7 insertions(+), 9 deletions(-)

Thanks Miroslav for wrapping this up, and thanks to Petr for his
previous work on this.

Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh
