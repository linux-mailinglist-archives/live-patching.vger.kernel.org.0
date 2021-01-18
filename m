Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3F32FA271
	for <lists+live-patching@lfdr.de>; Mon, 18 Jan 2021 15:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392580AbhAROD2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Jan 2021 09:03:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:56934 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392403AbhARODW (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Jan 2021 09:03:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610978552; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GJxA8ykhu2gJcqk6GIjIQ72lO2tZ7uSgCwBGZqoXgTY=;
        b=bYTaeWSbgdDHExIvEQ8+GQF6by4jSVSrmqICY7FJrND8ciggg6rTz6zK9BPMZvoqMwBAkB
        R9IojjnyCK0Lp26njKSe7gufb7odC0Wx3rjAWfjWUX/DWTtTgtxHfm/Nsga8CKYI1+jD7l
        uz00RpOLxwA0X2u/TV2UI8p69DhGT8w=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7FD35ACBA;
        Mon, 18 Jan 2021 14:02:32 +0000 (UTC)
Date:   Mon, 18 Jan 2021 15:02:31 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Miroslav Benes <mbenes@suse.cz>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v4] Documentation: livepatch: document reliable stacktrace
Message-ID: <YAWU0D50KH4mVTgn@alley>
References: <20210115171617.47273-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115171617.47273-1-broonie@kernel.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Mark,

first, thanks a lot for writing this.

On Fri 2021-01-15 17:16:17, Mark Brown wrote:
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
> I've tried to give rationale for all the recommendations/requirements,
> since that makes it easier to spot nearby issues, or when a check
> happens to catch a few things at once.

The above looks enough for the commit message. Well, Josh, typically
asks for a directive style, example:

Instead of "I've tried to give rationale...", please use something like
"The documentation gives rationale...".

> I believe what I have written is
> sound, but as some of this was reverse-engineered I may have missed
> things worth noting.
> 
> I've made a few assumptions about preferred behaviour, notably:
> 
> * If you can reliably unwind through exceptions, you should (as x86_64
>   does).
> 
> * It's fine to omit ftrace_return_to_handler and other return
>   trampolines so long as these are not subject to patching and the
>   original return address is reported. Most architectures do this for
>   ftrace_return_handler, but not other return trampolines.
> 
> * For cases where link register unreliability could result in duplicate
>   entries in the trace or an inverted trace, I've assumed this should be
>   treated as unreliable. This specific case shouldn't matter to
>   livepatching, but I assume that that we want a reliable trace to have
>   the correct order.

This looks like a background that is typically part of the cover
leter. It mentions some Mark's doubts.

Could anyone please answer whether the above assumptions are correct
or not? We should remove them from the commit message. If any
assumption is wrong, we should fix the documentation.

Honestly, I am curious about the anwer. I am not familiar with
these details of the reliable stacktrace ;-)


Otherwise, it looks good to me on the first look. But I am not
expert in this are, so I could not check the details effectively.

Best Regards,
Petr
