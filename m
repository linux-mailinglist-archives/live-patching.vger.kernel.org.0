Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192812FAA12
	for <lists+live-patching@lfdr.de>; Mon, 18 Jan 2021 20:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393946AbhART0M (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Jan 2021 14:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437083AbhARTZz (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Jan 2021 14:25:55 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E179CC061573;
        Mon, 18 Jan 2021 11:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=Q6zrLENp7cpbXPMaYRpxDAvz+iUlMtTGJHqGGUHDkNw=; b=MwdkcrdKCCy/r/oO2vxDBvd4zs
        blbaUZLfqFCCGI0Osevuivt7Y4F7rCbxSFeYwOzNwBwrNJRxpabbMDEbM0qeQEGB8O5gOoHLh5YB2
        PRzm1MZkZYnzJqKgH2m2bDqFRbaX59wzu3s4MK5hN3zgrmvd4UgbvF3hLRjat9DTzmeY0tdUILcA/
        haZtLWMyjpQwoEfDREEUlyFMSn1eqoYBh1TnxRbcLnkiLk0oOZVuZUr1v+r4njUhGwPH29AaU1gBu
        t3LhqbepJ0A3bTIPKlbYVvHGjG1lx9eSi10FFTn8FVzZbTeWyC2LDS++3eAnKvpTn7JuYw0Q0Azit
        2XUDKgJQ==;
Received: from [2601:1c0:6280:3f0::9abc]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l1a9H-0006jq-Qg; Mon, 18 Jan 2021 19:25:12 +0000
Subject: Re: [PATCH v5 2/2] Documentation: livepatch: document reliable
 stacktrace
To:     Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-doc@vgert.kernel.org, live-patching@vger.kernel.org
References: <20210118173954.36577-1-broonie@kernel.org>
 <20210118173954.36577-3-broonie@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e0243599-f650-9b8e-0ccc-68b6163668f3@infradead.org>
Date:   Mon, 18 Jan 2021 11:25:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210118173954.36577-3-broonie@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

On 1/18/21 9:39 AM, Mark Brown wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> Add documentation for reliable stacktrace. This is intended to describe
> the semantics and to be an aid for implementing architecture support for
> HAVE_RELIABLE_STACKTRACE.
> 
> Unwinding is a subtle area, and architectures vary greatly in both
> implementation and the set of concerns that affect them, so I've tried
> to avoid making this too specific to any given architecture. I've used
> examples from both x86_64 and arm64 to explain corner cases in more
> detail, but I've tried to keep the descriptions sufficient for those who
> are unfamiliar with the particular architecture.
> 
> This document aims to give rationale for all the recommendations and
> requirements, since that makes it easier to spot nearby issues, or when
> a check happens to catch a few things at once.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> [Updates following review -- broonie]
> Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  Documentation/livepatch/index.rst             |   1 +
>  .../livepatch/reliable-stacktrace.rst         | 309 ++++++++++++++++++
>  2 files changed, 310 insertions(+)
>  create mode 100644 Documentation/livepatch/reliable-stacktrace.rst

> diff --git a/Documentation/livepatch/reliable-stacktrace.rst b/Documentation/livepatch/reliable-stacktrace.rst
> new file mode 100644
> index 000000000000..fb123ee33403
> --- /dev/null
> +++ b/Documentation/livepatch/reliable-stacktrace.rst
> @@ -0,0 +1,309 @@

> +4.4 Rewriting of return addresses
> +---------------------------------
> +
> +Some trampolines temporarily modify the return address of a function in order
> +to intercept when that function returns with a return trampoline, e.g.
> +
> +* An ftrace trampoline may modify the return address so that function graph
> +  tracing can intercept returns.
> +
> +* A kprobes (or optprobes) trampoline may modify the return address so that
> +  kretprobes can intercept returns.
> +
> +When this happens, the original return address will not be in its usual
> +location. For trampolines which are not subject to live patching, where an
> +unwinder can reliably determine the original return address and no unwind state
> +is altered by the trampoline, the unwinder may report the original return
> +address in place of the trampoline and report this as reliable. Otherwise, an
> +unwinder must report these cases as unreliable.
> +
> +Special care is required when identifying the original return address, as this
> +information is not in a consistent location for the duration of the entry
> +trampoline or return trampoline. For example, considering the x86_64
> +'return_to_handler' return trampoline:
> +
> +.. code-block:: none
> +
> +   SYM_CODE_START(return_to_handler)
> +           UNWIND_HINT_EMPTY
> +           subq  $24, %rsp
> +
> +           /* Save the return values */
> +           movq %rax, (%rsp)
> +           movq %rdx, 8(%rsp)
> +           movq %rbp, %rdi
> +
> +           call ftrace_return_to_handler
> +
> +           movq %rax, %rdi
> +           movq 8(%rsp), %rdx
> +           movq (%rsp), %rax
> +           addq $24, %rsp
> +           JMP_NOSPEC rdi
> +   SYM_CODE_END(return_to_handler)
> +
> +While the traced function runs its return address points on the stack points to

too many "points" above.

Otherwise:

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> +the start of return_to_handler, and the original return address is stored in
> +the task's cur_ret_stack. During this time the unwinder can find the return
> +address using ftrace_graph_ret_addr().
> +
> +When the traced function returns to return_to_handler, there is no longer a
> +return address on the stack, though the original return address is still stored
> +in the task's cur_ret_stack. Within ftrace_return_to_handler(), the original
> +return address is removed from cur_ret_stack and is transiently moved
> +arbitrarily by the compiler before being returned in rax. The return_to_handler
> +trampoline moves this into rdi before jumping to it.
> +
> +Architectures might not always be able to unwind such sequences, such as when
> +ftrace_return_to_handler() has removed the address from cur_ret_stack, and the
> +location of the return address cannot be reliably determined.
> +
> +It is recommended that architectures unwind cases where return_to_handler has
> +not yet been returned to, but architectures are not required to unwind from the
> +middle of return_to_handler and can report this as unreliable. Architectures
> +are not required to unwind from other trampolines which modify the return
> +address.



-- 
~Randy
You can't do anything without having to do something else first.
-- Belefant's Law
