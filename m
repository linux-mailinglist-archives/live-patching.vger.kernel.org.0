Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC34D79D5
	for <lists+live-patching@lfdr.de>; Tue, 15 Oct 2019 17:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387526AbfJOPbd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Oct 2019 11:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733265AbfJOPbd (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Oct 2019 11:31:33 -0400
Received: from linux-8ccs (ip5f5adbbb.dynamic.kabel-deutschland.de [95.90.219.187])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2A7E20640;
        Tue, 15 Oct 2019 15:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571153492;
        bh=/yZECSqFbWBM+e6pr6Kd5FtztUG0bQpf7Ebo3eMkr4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qpniGNXnqcLyiiO/RRW9XTnDa4FejS5RQpnNbcvdVBprpweRnstkoVNPSM186i3u/
         QvNSUgmnGm0gkq1WLc4rTyy0xdwNki9GMlO2aJoeh7T3IcdReTIB9KQyAvAAIte9xL
         Jo47KrGF4zgd9S3rbMzlmswUUXphuGOtdQQQ5I8c=
Date:   Tue, 15 Oct 2019 17:31:20 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jpoimboe@redhat.com,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
Message-ID: <20191015153120.GA21580@linux-8ccs>
References: <20191010092054.GR2311@hirez.programming.kicks-ass.net>
 <20191010091956.48fbcf42@gandalf.local.home>
 <20191010140513.GT2311@hirez.programming.kicks-ass.net>
 <20191010115449.22044b53@gandalf.local.home>
 <20191010172819.GS2328@hirez.programming.kicks-ass.net>
 <20191011125903.GN2359@hirez.programming.kicks-ass.net>
 <20191015130739.GA23565@linux-8ccs>
 <20191015135634.GK2328@hirez.programming.kicks-ass.net>
 <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz>
 <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.28-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+++ Joe Lawrence [15/10/19 11:06 -0400]:
>On 10/15/19 10:13 AM, Miroslav Benes wrote:
>>Yes, it does. klp_module_coming() calls module_disable_ro() on all
>>patching modules which patch the coming module in order to call
>>apply_relocate_add(). New (patching) code for a module can be relocated
>>only when the relevant module is loaded.
>
>FWIW, would the LPC blue-sky2 model (ie, Steve's suggestion @ 
>plumber's where livepatches only patch a single object and updates are 
>kept on disk to handle coming module updates as they are loaded) 
>eliminate those outstanding relocations and the need to perform this 
>late permission flipping?

I wasn't at Plumbers sadly, was this idea documented/talked about in
detail somewhere? (recording, slides, etherpad, etc?). What do you
mean by updates are kept on disk? Maybe someone can explain it more
in detail? :)

