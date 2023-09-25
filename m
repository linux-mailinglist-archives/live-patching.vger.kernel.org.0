Return-Path: <live-patching+bounces-8-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 338FF7ADF60
	for <lists+live-patching@lfdr.de>; Mon, 25 Sep 2023 21:03:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sv.mirrors.kernel.org (Postfix) with ESMTP id B50A32812A2
	for <lists+live-patching@lfdr.de>; Mon, 25 Sep 2023 19:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1053E1D6B0;
	Mon, 25 Sep 2023 19:03:29 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FD81C29A
	for <live-patching@vger.kernel.org>; Mon, 25 Sep 2023 19:03:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E82093
	for <live-patching@vger.kernel.org>; Mon, 25 Sep 2023 12:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695668602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fzBSf4JXBw9DG2ter3Ft2dbMxjnf+RIRHcyGZ86okTg=;
	b=A4WpXTjABRadvROVqhefzL8HqvLDvHTTYPal5fRNCqBfc/qO7LMTKoDqK+XvGLn4gu+ZIr
	Ywo3322vYUajnVNi+Z2j+f7FqIWj6g0a0r/ZVRceIXg7sDEW3f6DQfS5I+weqqguhgETgJ
	ccD98Gk4iH0IL389InHvPlX6A1mNnWc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-308-NtUsmupsMqCxS1_LtyUfhw-1; Mon, 25 Sep 2023 15:03:14 -0400
X-MC-Unique: NtUsmupsMqCxS1_LtyUfhw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 731C53C11A08;
	Mon, 25 Sep 2023 19:02:52 +0000 (UTC)
Received: from redhat.com (unknown [10.22.8.202])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B30240C2064;
	Mon, 25 Sep 2023 19:02:52 +0000 (UTC)
Date: Mon, 25 Sep 2023 15:02:50 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, npiggin@gmail.com, pmladek@suse.com,
	live-patching@vger.kernel.org
Subject: Re: [PATCH] powerpc/stacktrace: Fix arch_stack_walk_reliable()
Message-ID: <ZRHZWpppf7iuA3Gs@redhat.com>
References: <20230921232441.1181843-1-mpe@ellerman.id.au>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921232441.1181843-1-mpe@ellerman.id.au>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Sep 22, 2023 at 09:24:41AM +1000, Michael Ellerman wrote:
> The changes to copy_thread() made in commit eed7c420aac7 ("powerpc:
> copy_thread differentiate kthreads and user mode threads") inadvertently
> broke arch_stack_walk_reliable() because it has knowledge of the stack
> layout.
> 
> Fix it by changing the condition to match the new logic in
> copy_thread(). The changes make the comments about the stack layout
> incorrect, rather than rephrasing them just refer the reader to
> copy_thread().
> 
> Also the comment about the stack backchain is no longer true, since
> commit edbd0387f324 ("powerpc: copy_thread add a back chain to the
> switch stack frame"), so remove that as well.
> 
> Reported-by: Joe Lawrence <joe.lawrence@redhat.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Fixes: eed7c420aac7 ("powerpc: copy_thread differentiate kthreads and user mode threads")
> ---
>  arch/powerpc/kernel/stacktrace.c | 27 +++++----------------------
>  1 file changed, 5 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/stacktrace.c b/arch/powerpc/kernel/stacktrace.c
> index b15f15dcacb5..e6a958a5da27 100644
> --- a/arch/powerpc/kernel/stacktrace.c
> +++ b/arch/powerpc/kernel/stacktrace.c
> @@ -73,29 +73,12 @@ int __no_sanitize_address arch_stack_walk_reliable(stack_trace_consume_fn consum
>  	bool firstframe;
>  
>  	stack_end = stack_page + THREAD_SIZE;
> -	if (!is_idle_task(task)) {
> -		/*
> -		 * For user tasks, this is the SP value loaded on
> -		 * kernel entry, see "PACAKSAVE(r13)" in _switch() and
> -		 * system_call_common().
> -		 *
> -		 * Likewise for non-swapper kernel threads,
> -		 * this also happens to be the top of the stack
> -		 * as setup by copy_thread().
> -		 *
> -		 * Note that stack backlinks are not properly setup by
> -		 * copy_thread() and thus, a forked task() will have
> -		 * an unreliable stack trace until it's been
> -		 * _switch()'ed to for the first time.
> -		 */
> -		stack_end -= STACK_USER_INT_FRAME_SIZE;
> -	} else {
> -		/*
> -		 * idle tasks have a custom stack layout,
> -		 * c.f. cpu_idle_thread_init().
> -		 */
> +
> +	// See copy_thread() for details.
> +	if (task->flags & PF_KTHREAD)
>  		stack_end -= STACK_FRAME_MIN_SIZE;
> -	}
> +	else
> +		stack_end -= STACK_USER_INT_FRAME_SIZE;
>  
>  	if (task == current)
>  		sp = current_stack_frame();
> -- 
> 2.41.0
> 
> 

Reviewed-by: Joe Lawrence <joe.lawrence@redhat.com>

Thanks for posting, Michael.

Livepatching kselftests are happy now.  Minimal kpatch testing good, too
(we have not rebased our full integration tests to latest upstreams just
yet).

--
Joe


