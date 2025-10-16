Return-Path: <live-patching+bounces-1756-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6743FBE2FCA
	for <lists+live-patching@lfdr.de>; Thu, 16 Oct 2025 13:00:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B1ED4508B73
	for <lists+live-patching@lfdr.de>; Thu, 16 Oct 2025 10:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55A032D46D6;
	Thu, 16 Oct 2025 10:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YuMlXSG9"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5019328627
	for <live-patching@vger.kernel.org>; Thu, 16 Oct 2025 10:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760612199; cv=none; b=AnDZ0p5QyOfqhvETOxOu303f0Mh3wN5oaECE4OFNUAzZJ7+a3gQJdhbe3Xi76rXhdRpWEGjrrFy82Uqz3m5CXtbHaWH1PGU7QeGuUZRKmduHblH+IQfODQkfp4b376HLFRao4MVvh3E5ch9hZ85WJIRo+IUrKZegt/nIgm1QOrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760612199; c=relaxed/simple;
	bh=dfbcc+GPFVIvEe9lR6qXbX60p447FFkIVmsVHjVQgeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qct2xE8pTye2L979epGUDDt8bSQGbKMaieMilLCq4ku2k3Kh3vvLpjpZN4zd2XmNClC2fE6NqI7Ody2Q7HCDc78cfRHYfguDJMAW75/of4FJdbces9+oHSefjCcNwGSuAouarO7kn2MCQsqtmSElMkfD7Gfd1ajTsaAxnutdl7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YuMlXSG9; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4710683a644so5695685e9.0
        for <live-patching@vger.kernel.org>; Thu, 16 Oct 2025 03:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760612195; x=1761216995; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JvMyvJix2INUFF3DP9woWEjrzPg/FTJBbbZmiLKMmZE=;
        b=YuMlXSG9AiVYuMEqKOl6JRnA2oH82Ny3UEdOcnrJWo7awo2TeWnE60Q2SJB7HIeQdA
         +3+guy7hIm6TQfs0Urv9Yn0MPUk2nnmjE0o/q5AbLjwUSQZuNpE2gfWJymORlwWTMHln
         F+DJeW1+QEEPPD4tTuxBXuODzdVUsARVj0JNM64kbbIK5WaksKvKixzCLzPZ61wz3nLq
         sbb1xQSOu55PG/8TAkrUr1I0p8esRRUi03o65h1IeXHYS2u2zH0ZS3xmT/XIHL8gtuNH
         o8mVygbr6VUWN2TD+fCh1as0Cmwre7oavqJrQFlJXy+Y254uUJKFOr4hYek3HbMlfDM3
         I86g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760612195; x=1761216995;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JvMyvJix2INUFF3DP9woWEjrzPg/FTJBbbZmiLKMmZE=;
        b=Yd+clU4NOvm4/5xVE42U0xhEK7uN5SuGhoDLdo3BLxhf6fVLys32VBubVwHMP1fQmU
         UyAz4Yv0oguKI4OL+uv4qaDtjSPXFws/1rmMT3HcF4pdCAZrfm6ljqBf2TPqraHYWIwI
         ocuYxCS6hcZ2dFlwvF7mghUBAOvuhsR2ykgEVIa0cQQ42rvVf8r/2vRKGMAVFWHk8yk/
         +Zpol1QRp+I28HvAHZmmiOYO4/ERq+85WabxmCXZIAxvZtFo5QdyfV+CavNcmpklaXhx
         f6qK6vHqIj+o1nC/QzL0Q4p33q61XpY9eIQ+NbVJRzGstz9YaUK6cjFxLaIm9Hl9LS3y
         HJUA==
X-Forwarded-Encrypted: i=1; AJvYcCUB7N73VQljnMw/9TZMLL05ZB+ocpOWf4VUgrJwVON4N7vH/OMZsXcQfPHw33/7sMjF70Efmi46arS3gXtC@vger.kernel.org
X-Gm-Message-State: AOJu0Yy36ROhHRzQMo/L8yU+fBfiGc9yJ8uiEgUq/7kvSSrbV5yyBh3E
	cLfiOJssS8QmsuuOWLxCn1waAb+cQ8Glv2dfb0659L7WgzwWf9vmrB+y9uROMb0V2iBCpg17m04
	otxb6
X-Gm-Gg: ASbGncvQHdlCZvYnVo/+ZSeFi9Lj7k1bH1Pek2/8NB9yy5hm2SUtZV9fxBCfAd51s25
	vQ5qQyLpDk5VReaatNLrxCb9aiBMEeLEldqMIwCWDBkCxjkLAmdqY0Tq/35FZvYpklnKt71cRzZ
	RjUjGnOqUC+tA1iuwSWmzLsY+ZGzny6XjkmZBbl0yHHhaTsBevsRm+joTo2W4B2Tc34tRKooS84
	j1iSltzbW4aYDp2HyAp8VQA6dqjhb1l6qK1Xs/YqUtM26j6ffTJMHK0bRzCCGupKIvPAD+Vd6bW
	6wfqzUCr+kycIDjv6Pj4HXz5XKb7+01LRYPKYVbSBqkTMS18tkQ2ZsvPWNp6lLGGgfLNvKgsjcg
	47torv/BTJbt1Bqa6RU0sdDP0+hscHf8gHkeJjrrkZ+xRsjqjacC/EnHaDWZAF5P0/7kosSdC9d
	lwrC4XK3UCMj9lwA==
X-Google-Smtp-Source: AGHT+IGSXEqn8oN+HcXgwUrEwwh6eJyfsdVDbgwENyfxhJiL99iGOX5y+EgIo99dFaG9CsMF8AVrHQ==
X-Received: by 2002:a05:600c:870c:b0:45f:29eb:2148 with SMTP id 5b1f17b1804b1-47109a23782mr23569575e9.7.1760612194830;
        Thu, 16 Oct 2025 03:56:34 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5cfe69sm35181042f8f.32.2025.10.16.03.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 03:56:34 -0700 (PDT)
Date: Thu, 16 Oct 2025 12:56:32 +0200
From: Petr Mladek <pmladek@suse.com>
To: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Cc: "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
	Song Liu <song@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [External] Re: Question - Livepatch/Kprobe Coexistence on
 Ftrace-enabled Functions (Ubuntu kernel based on Linux stable 5.15.30)
Message-ID: <aPDPYIA4_mpo-OZS@pathway.suse.cz>
References: <c5058315a39d4615b333e485893345be@crowdstrike.com>
 <aO-LMaY-os44cEJP@pathway.suse.cz>
 <eb176565-6e13-4f98-8c9a-cacf7fc42f3a@crowdstrike.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eb176565-6e13-4f98-8c9a-cacf7fc42f3a@crowdstrike.com>

Added Song Liu and Steven into Cc because they are more familiar with
the ftrace trampolines.

On Wed 2025-10-15 17:11:31, Andrey Grodzovsky wrote:
> On 10/15/25 07:53, Petr Mladek wrote:
> > On Tue 2025-10-14 21:37:49, Andrey Grodzovsky wrote:
> > > Dear Upstream Livepatch  team and Ubuntu Kernel team - I included you both in this since the issue lies on the boundary between Ubuntu kernel and upstream.
> > > 
> > > According to official kernel documentation  - https://urldefense.com/v3/__https://docs.kernel.org/livepatch/livepatch.html*livepatch__;Iw!!BmdzS3_lV9HdKG8!z3Y4vlE7RcCriT3z4Hg7cVaojZPN-ysQTbjDJVXyO_MoRRlkKsymUTDP4PGvvPaV0TDVYhziOYMm9WnUGu5TeFxUxQ$ , section 7, Limitations -
> > > 1 - Kretprobes using the ftrace framework conflict with the patched functions.
> > > 2 - Kprobes in the original function are ignored when the code is redirected to the new implementation.
> > > 
> > > Yet, when testing on my Ubuntu 5.15.0-1005.7-aws (based on 5.15.30 stable kernel) machine, I have no problem applying Livepatch and then setting krpobes and kretprobes on a patched function using bpftrace (or directly by coding a BPF program with kprobe/kretprobe attachment)and can confirm both execute without issues. Also the opposite works fine, running my krpobe and kretprobe hooks doesn't prevent from livepatch to be applied successfully.
> > > 
> > > fentry/fexit probes do fail in in both directions - but this is expected according to my understanding as coexistence of livepatching and ftrace based BPF hooks are mutually exclusive until 6.0 based kernels
> > > 
> > > libbpf: prog 'begin_new_exec_fentry': failed to attach: Device or resource busy
> > > libbpf: prog 'begin_new_exec_fentry': failed to auto-attach: -16
> > > 
> > > 
> > > Please help me understand this contradiction about kprobes - is this because the KPROBES are FTRACE based  or any other reason ?
> > Heh, it seems that we have discussed this 10 years ago and I already
> > forgot most details.
> > 
> > Yes, the conflict is detected when KPROBES are using FTRACE
> > infrastructure. But it happens only when the KPROBE needs to redirect
> > the function call, namely when it needs to modify IP address which will be used
> > when all attached ftrace callbacks are proceed.
> > 
> > It is related to the FTRACE_OPS_FL_IPMODIFY flag.
> 
> 
> I see, that explains my case as my probes are simple, print only probes that
> defently don't that the ip pointer.
> 
> But i still don't understand limitation 2 above doesn't show itself - how my
> kprobes and especially kretprobes, continue execute even after livepatch
> applied to the function  i am attached to ? The code execution is redirected
> to a different function then to which i attached my probes...

The code is rather complicated and it is not obvious to me.

But I expect that kretprobes modify return addresses which are
stored on the stack. They replace them
with a helper function (trampoline) which would process
the kretprobe callback and jump to the original return address.

It works even with livepatching. The only requirement is that
the function returns using a "ret" instruction which reads
the return address from the stack.

> Also - can you please confirm that as far as i checked, starting with kernel
> 6.0 fentry/fexit on x86 should not have any conflicts with livepatch per
> merge of this RFC -
> https://lkml.iu.edu/hypermail/linux/kernel/2207.2/00858.html ?

My understanding is that the above mentioned patchset allowed to use
livepatching and BPF on the same function at the same time. BPF used
to redirect the function to a BPF trampoline. And the patchset allowed
to call the BPF trampoline/callback directly from the ftrace callback.

Best Regards,
Petr

> > 
> > More details can be found in the discussion at
> > https://urldefense.com/v3/__https://lore.kernel.org/all/20141121102516.11844.27829.stgit@localhost.localdomain/T/*re746846b6b16c49a55c89b4c63b7995fe5972111__;Iw!!BmdzS3_lV9HdKG8!z3Y4vlE7RcCriT3z4Hg7cVaojZPN-ysQTbjDJVXyO_MoRRlkKsymUTDP4PGvvPaV0TDVYhziOYMm9WnUGu6pjuIgig$
> > 
> > I seems that I made some analyze when it worked and it did not work,
> > see https://urldefense.com/v3/__https://lore.kernel.org/all/20141121102516.11844.27829.stgit@localhost.localdomain/T/*mffd8c8bf4325b473d89876f2805f42f1af7c82d7__;Iw!!BmdzS3_lV9HdKG8!z3Y4vlE7RcCriT3z4Hg7cVaojZPN-ysQTbjDJVXyO_MoRRlkKsymUTDP4PGvvPaV0TDVYhziOYMm9WnUGu5xbeoulA$
> > But I am not 100% sure that it was correct. Also it was before the
> > BPF-boom.
> > 
> > Also you might look at the selftest in the todays Linus' tree:
> > 
> >    + tools/testing/selftests/livepatch/https://urldefense.com/v3/__http://test-kprobe.sh__;!!BmdzS3_lV9HdKG8!z3Y4vlE7RcCriT3z4Hg7cVaojZPN-ysQTbjDJVXyO_MoRRlkKsymUTDP4PGvvPaV0TDVYhziOYMm9WnUGu5RXF-AnA$
> >    + tools/testing/selftests/livepatch/test_modules/test_klp_kprobe.c
> >    + tools/testing/selftests/livepatch/test_modules/test_klp_livepatch.c
> > 
> > The parallel load fails when the Kprobe is using a post_handler.
> > 
> > Sigh, we should fix the livepatch documentation. The kretprobes
> > obviously work. register_kretprobe() even explicitely sets:
> > 
> > 	rp->kp.post_handler = NULL;
> > 
> > It seems that .post_handler is called after all ftrace handlers.
> > And it sets IP after the NOPs, see kprobe_ftrace_handler().
> > I am not sure about the use case.
> > 
> > Best Regards,
> > Petr
> 
> 

