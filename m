Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB7C346B78
	for <lists+live-patching@lfdr.de>; Fri, 14 Jun 2019 23:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbfFNVEL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 14 Jun 2019 17:04:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfFNVEL (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 14 Jun 2019 17:04:11 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFE8F217F9;
        Fri, 14 Jun 2019 21:04:09 +0000 (UTC)
Date:   Fri, 14 Jun 2019 17:04:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Jessica Yu <jeyu@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/3] module: Fix livepatch/ftrace module text
 permissions race
Message-ID: <20190614170408.1b1162dc@gandalf.local.home>
In-Reply-To: <ab43d56ab909469ac5d2520c5d944ad6d4abd476.1560474114.git.jpoimboe@redhat.com>
References: <cover.1560474114.git.jpoimboe@redhat.com>
        <ab43d56ab909469ac5d2520c5d944ad6d4abd476.1560474114.git.jpoimboe@redhat.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 13 Jun 2019 20:07:22 -0500
Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> It's possible for livepatch and ftrace to be toggling a module's text
> permissions at the same time, resulting in the following panic:
> 

[..]

> The above panic occurs when loading two modules at the same time with
> ftrace enabled, where at least one of the modules is a livepatch module:
> 
> CPU0					CPU1
> klp_enable_patch()
>   klp_init_object_loaded()
>     module_disable_ro()
>     					ftrace_module_enable()
> 					  ftrace_arch_code_modify_post_process()
> 				    	    set_all_modules_text_ro()
>       klp_write_object_relocations()
>         apply_relocate_add()
> 	  *patches read-only code* - BOOM
> 
> A similar race exists when toggling ftrace while loading a livepatch
> module.
> 
> Fix it by ensuring that the livepatch and ftrace code patching
> operations -- and their respective permissions changes -- are protected
> by the text_mutex.
> 
> Reported-by: Johannes Erdfelt <johannes@erdfelt.com>
> Fixes: 444d13ff10fb ("modules: add ro_after_init support")
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Acked-by: Jessica Yu <jeyu@kernel.org>
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Reviewed-by: Miroslav Benes <mbenes@suse.cz>

This patch looks uncontroversial. I'm going to pull this one in and
start testing it. And if it works, I'll push to Linus.

-- Steve

