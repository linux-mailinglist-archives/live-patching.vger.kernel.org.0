Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6288458E20
	for <lists+live-patching@lfdr.de>; Fri, 28 Jun 2019 00:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfF0Wrl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 27 Jun 2019 18:47:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55690 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbfF0Wrl (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 27 Jun 2019 18:47:41 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3782B19DD1;
        Thu, 27 Jun 2019 22:47:41 +0000 (UTC)
Received: from treble (ovpn-126-66.rdu2.redhat.com [10.10.126.66])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5051519C4F;
        Thu, 27 Jun 2019 22:47:31 +0000 (UTC)
Date:   Thu, 27 Jun 2019 17:47:29 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>, mhiramat@kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH] ftrace: Remove possible deadlock between
 register_kprobe() and ftrace_run_update_code()
Message-ID: <20190627224729.tshtq4bhzhneq24w@treble>
References: <20190627081334.12793-1-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190627081334.12793-1-pmladek@suse.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 27 Jun 2019 22:47:41 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Thanks a lot for fixing this Petr.

On Thu, Jun 27, 2019 at 10:13:34AM +0200, Petr Mladek wrote:
> @@ -35,6 +36,7 @@
>  
>  int ftrace_arch_code_modify_prepare(void)
>  {
> +	mutex_lock(&text_mutex);
>  	set_kernel_text_rw();
>  	set_all_modules_text_rw();
>  	return 0;
> @@ -44,6 +46,7 @@ int ftrace_arch_code_modify_post_process(void)
>  {
>  	set_all_modules_text_ro();
>  	set_kernel_text_ro();
> +	mutex_unlock(&text_mutex);
>  	return 0;
>  }

Releasing the lock in a separate function seems a bit surprising and
fragile, would it be possible to do something like this instead?

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index b38c388d1087..89ea1af6fd13 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -37,15 +37,21 @@
 int ftrace_arch_code_modify_prepare(void)
 {
 	mutex_lock(&text_mutex);
+
 	set_kernel_text_rw();
 	set_all_modules_text_rw();
+
+	mutex_unlock(&text_mutex);
 	return 0;
 }
 
 int ftrace_arch_code_modify_post_process(void)
 {
+	mutex_lock(&text_mutex);
+
 	set_all_modules_text_ro();
 	set_kernel_text_ro();
+
 	mutex_unlock(&text_mutex);
 	return 0;
 }
