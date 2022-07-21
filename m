Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A1357D758
	for <lists+live-patching@lfdr.de>; Fri, 22 Jul 2022 01:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbiGUXYO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Jul 2022 19:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbiGUXYL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Jul 2022 19:24:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585688E6DC;
        Thu, 21 Jul 2022 16:24:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC33E61EC5;
        Thu, 21 Jul 2022 23:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44398C341CB;
        Thu, 21 Jul 2022 23:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658445849;
        bh=P/6rQAdP9rzBa942itCTf9L8nhPLhGKaMmQZTpYf4lg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LCjX/b+iSIxZjZQvd2rfDS16Fe/nEBFHCWFQRZZiEGGGot0e0lmmUYR6uidyMQpSH
         X1V+KsxX1lNZ24O1aV3TFzo0DAbRI2Nlf7eJH3HJXKxakQhr9mHYx7m+30xpUWVApA
         9yjbNFAkYT/OHttaaV/9B4mr9bSlPMJui4zJeYhIZ7YtkgMwVJtEdGQElyF+oAB2/9
         8PP97tH6HEiif4pIS7/rFyhEpMRGV4avHThC/ayQVct7WfqKpZTyNRYpUQMzh3+qor
         enkacwShLkAXxtLmUKoT8jAurXoHZiecxr7wGs6GsgbZieunEGQIB+38zh5ixXW/vi
         p7jfStDD9CH4A==
Received: by mail-yb1-f177.google.com with SMTP id 7so5470940ybw.0;
        Thu, 21 Jul 2022 16:24:09 -0700 (PDT)
X-Gm-Message-State: AJIora/EPO1fx6ztpTlMKOIM/Pb2UOXcFNdns4dc6hCffgPuPMCQTmEK
        NTmSOUyWR3aDglflor9D7eLID3pY1P92mS9zJVQ=
X-Google-Smtp-Source: AGRyM1smN1yeQHGHgzK10Jgw0OKeuQqhEyEHb9girmGnrEBu3bk2jPzkRSRcbT4DOosj+rm1JUODkdyiYn0eC6Trjjg=
X-Received: by 2002:a25:8611:0:b0:66e:d9e7:debc with SMTP id
 y17-20020a258611000000b0066ed9e7debcmr798529ybk.257.1658445848324; Thu, 21
 Jul 2022 16:24:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220720121023.043738bb@imladris.surriel.com>
In-Reply-To: <20220720121023.043738bb@imladris.surriel.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 21 Jul 2022 16:23:57 -0700
X-Gmail-Original-Message-ID: <CAPhsuW71nehoDGTyeAvFgpTJFd1Et5GeMpqMiObzbP2g5uRVqA@mail.gmail.com>
Message-ID: <CAPhsuW71nehoDGTyeAvFgpTJFd1Et5GeMpqMiObzbP2g5uRVqA@mail.gmail.com>
Subject: Re: [PATCH,RFC] livepatch: fix race between fork and klp_reverse_transition
To:     Rik van Riel <riel@surriel.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org, Kernel Team <kernel-team@fb.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Breno Leitao <leitao@debian.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jul 20, 2022 at 9:20 AM Rik van Riel <riel@surriel.com> wrote:
>
> When a KLP fails to apply, klp_reverse_transition will clear the
> TIF_PATCH_PENDING flag on all tasks, except for newly created tasks
> which are not on the task list yet.
>
> Meanwhile, fork will copy over the TIF_PATCH_PENDING flag from the
> parent to the child early on, in dup_task_struct -> setup_thread_stack.
>
> Much later, klp_copy_process will set child->patch_state to match
> that of the parent.
>
> However, the parent's patch_state may have been changed by KLP loading
> or unloading since it was initially copied over into the child.
>
> This results in the KLP code occasionally hitting this warning in
> klp_complete_transition:
>
>         for_each_process_thread(g, task) {
>                 WARN_ON_ONCE(test_tsk_thread_flag(task, TIF_PATCH_PENDING));
>                 task->patch_state = KLP_UNDEFINED;
>         }
>
> This patch will set, or clear, the TIF_PATCH_PENDING flag in the child
> process depending on whether or not it is needed at the time
> klp_copy_process is called, at a point in copy_process where the
> tasklist_lock is held exclusively, preventing races with the KLP
> code.
>
> This should prevent this warning from triggering again in the
> future.
>
> I have not yet figured out whether this would also help with races in
> the other direction, where the child process fails to have TIF_PATCH_PENDING
> set and somehow misses a transition, or whether the retries in
> klp_try_complete_transition would catch that task and help it transition
> later.
>
> Signed-off-by: Rik van Riel <riel@surriel.com>
> Reported-by: Breno Leitao <leitao@debian.org>

LGTM!
Acked-by: Song Liu <song@kernel.org>

> ---
>  kernel/livepatch/transition.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index 5d03a2ad1066..7a90ad5e9224 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -612,7 +612,15 @@ void klp_copy_process(struct task_struct *child)
>  {
>         child->patch_state = current->patch_state;
>
> -       /* TIF_PATCH_PENDING gets copied in setup_thread_stack() */
> +       /*
> +        * The parent process may have gone through a KLP transition since
> +        * the thread flag was copied in setup_thread_stack earlier. Set
> +        * the flag according to whether this task needs a KLP transition.
> +        */
> +       if (child->patch_state != klp_target_state)
> +               set_tsk_thread_flag(child, TIF_PATCH_PENDING);
> +       else
> +               clear_tsk_thread_flag(child, TIF_PATCH_PENDING);
>  }
>
>  /*
> --
> 2.35.1
>
