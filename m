Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A14A29AA63
	for <lists+live-patching@lfdr.de>; Tue, 27 Oct 2020 12:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2899065AbgJ0LQg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 27 Oct 2020 07:16:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:33158 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2899062AbgJ0LQf (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 27 Oct 2020 07:16:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1603797393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GnxDeGmTMUPaCY3lsvPzLW9g+uQZ2HFO8L2cAvETF+M=;
        b=Rn4TkiR6JDIP8AdqOgSa9mZ1yGMho72joE9GOMkfgcnsrjlqb9HUnkQBlgNyANXAKrrd6f
        2haG6Pv0L6EC3DDnbg9CNZo7MiDiIDqM7KSHD1+eih8HczaYo67lds/KrkXvHZT7U5WUN6
        SAq1gtwn2SkF4TmjL0q4qXKS6IzUgks=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3739FAF06;
        Tue, 27 Oct 2020 11:16:33 +0000 (UTC)
Date:   Tue, 27 Oct 2020 12:16:32 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     linux-kernel@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH] Documentation: livepatch: document reliable stacktrace
Message-ID: <20201027111559.GC31882@alley>
References: <20201023153527.36346-1-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023153527.36346-1-mark.rutland@arm.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2020-10-23 16:35:27, Mark Rutland wrote:
> Add documentation for reliable stacktrace. This is intended to describe
> the semantics and to be an aid for implementing architecture support for
> HAVE_RELIABLE_STACKTRACE.

First, thanks a lot for putting this document together.

I am not expert on stack unwinders and am not sure if some details
should get corrected and added. I believe that it can be done by
others more effectively.

Anyway, the document is well readable and provides a lot of useful
information. I suggest only small change in the style, see below.


> diff --git a/Documentation/livepatch/reliable-stacktrace.rst b/Documentation/livepatch/reliable-stacktrace.rst
> new file mode 100644
> index 0000000000000..d296c93f6f0e0
> --- /dev/null
> +++ b/Documentation/livepatch/reliable-stacktrace.rst
> +2. Requirements
> +===============
> +
> +Architectures must implement one of the reliable stacktrace functions.
> +Architectures using CONFIG_ARCH_STACKWALK should implement
> +'arch_stack_walk_reliable', and other architectures should implement
> +'save_stack_trace_tsk_reliable'.
> +
> +Principally, the reliable stacktrace function must ensure that either:
> +
> +* The trace includes all functions that the task may be returned to, and the
> +  return code is zero to indicate that the trace is reliable.
> +
> +* The return code is non-zero to indicate that the trace is not reliable.
> +
> +.. note::
> +   In some cases it is legitimate to omit specific functions from the trace,
> +   but all other functions must be reported. These cases are described in
> +   futher detail below.
> +
> +Secondly, the reliable stacktrace function should be robust to cases where the
> +stack or other unwind state is corrupt or otherwise unreliable. The function
> +should attempt to detect such cases and return a non-zero error code, and
> +should not get stuck in an infinite loop or access memory in an unsafe way.
> +Specific cases are described in further detail below.

Please, use imperative style when something is required for the
reliability. For example, it means replacing all "should" with "must"
in the above paragraph.

I perfectly understand why you used "should". I use it heavily as
well. But we really must motivate people to handle all corner
cases here. ;-)

Best Regards,
Petr
