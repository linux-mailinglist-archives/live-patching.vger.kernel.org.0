Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1056A46FDA5
	for <lists+live-patching@lfdr.de>; Fri, 10 Dec 2021 10:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239310AbhLJJ2o (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 10 Dec 2021 04:28:44 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:58720 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239270AbhLJJ2m (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 10 Dec 2021 04:28:42 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 9E5821F3A0;
        Fri, 10 Dec 2021 09:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639128305; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LycgmG/LOJGB73wFgPTNENwjnXJ/W6j/W+2P+mTUqtY=;
        b=tb2/CiUtZq6CXhb+haQSauUuxJ2aRwXLYj92PZMerEm2Pzwl5U7UeJlBqKoHIKhCSBSiVR
        rpY2eJZ4InS7utFOpfDp8kXr4P+UqgbleouwxHfPBlGIutdqDH3ndiLMThJZxsT7mWZ4MN
        /HqEs23frqLuieyu+GAxNU+lcBKbKrE=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 6F03CA3B95;
        Fri, 10 Dec 2021 09:25:05 +0000 (UTC)
Date:   Fri, 10 Dec 2021 10:25:05 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     David Vernet <void@manifault.com>
Cc:     linux-doc@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpoimboe@redhat.com,
        jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
        corbet@lwn.net, yhs@fb.com, songliubraving@fb.com
Subject: Re: [PATCH] Documentation: livepatch: Add kernel-doc link to
 klp_enable_patch
Message-ID: <YbMc8YGIoyRU5nwJ@alley>
References: <20211209165303.3205464-1-void@manifault.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211209165303.3205464-1-void@manifault.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2021-12-09 08:53:04, David Vernet wrote:
> The `klp_enable_patch()` function is the main entrypoint to the livepatch
> subsystem, and is invoked by a KLP module from the module_init callback
> when it is ready to be enabled.  The livepatch documentation specifies that
> `klp_enable_patch()` should be invoked from the `module_init()` callback,
> but does not actually link the user to the function's kerneldoc comment.
> 
> This simple change therefore adds a kernel-doc directive to link the
> `klp_enable_patch()` function's kerneldoc comment in the livepatch
> documentation page. With this, kernel/livepatch/core.c no longer comes up
> as a file containing an unused doc with
> `scripts/find-unused-docs.sh kernel/livepatch`
> 
> --- a/Documentation/livepatch/livepatch.rst
> +++ b/Documentation/livepatch/livepatch.rst
> @@ -312,8 +312,15 @@ the patch cannot get enabled.
>  -------------
>  
>  The livepatch gets enabled by calling klp_enable_patch() from
> -the module_init() callback. The system will start using the new
> -implementation of the patched functions at this stage.
> +the module_init() callback:
> +
> +.. kernel-doc:: kernel/livepatch/core.c
> +   :functions: klp_enable_patch
> +
> +----
> +
> +The system will start using the new implementation of the patched functions at
> +this stage.
>  
>  First, the addresses of the patched functions are found according to their
>  names. The special relocations, mentioned in the section "New functions",

Honestly, I do not like this. It might be acceptable when it converts
klp_enable_patch() into a link pointing to another page describing the API.

But this patch causes the entire documentation of klp_enable_patch()
inserted into livepatch.html. It does not fit there and breaks
the text flow.


Heh, I had hard times to build the documentation (sphinx crashed, ...).
So, I paste the html output for others here:

<cut&paste>
5.2. Enabling¶
The livepatch gets enabled by calling klp_enable_patch() from the module_init() callback:

int klp_enable_patch(struct klp_patch *patch)¶
enable the livepatch

Parameters

struct klp_patch *patch
patch to be enabled

Description

Initializes the data structure associated with the patch, creates the sysfs interface, performs the needed symbol lookups and code relocations, registers the patched functions with ftrace.

This function is supposed to be called from the livepatch module_init() callback.

Return

0 on success, otherwise error

The system will start using the new implementation of the patched functions at this stage.

First, the addresses of the patched functions are found according to their names. The special relocations, mentioned in the section “New functions”, are applied. The relevant entries are created under /sys/kernel/livepatch/<name>. The patch is rejected when any above operation fails.

Second, livepatch enters into a transition state where tasks are converging to the patched state. If an original function is patched for the first time, a function specific struct klp_ops is created and an universal ftrace handler is registered1. This stage is indicated by a value of ‘1’ in /sys/kernel/livepatch/<name>/transition. For more information about this process, see the “Consistency model” section.

Finally, once all tasks have been patched, the ‘transition’ value changes to ‘0’.

1
Note that functions might be patched multiple times. The ftrace handler is registered only once for a given function. Further patches just add an entry to the list (see field func_stack) of the struct klp_ops. The right implementation is selected by the ftrace handler, see the “Consistency model” section.

That said, it is highly recommended to use cumulative livepatches
because they help keeping the consistency of all changes. In this
case, functions might be patched two times only during the transition
period.
</cut&paste>


Best Regards,
Petr
