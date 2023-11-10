Return-Path: <live-patching+bounces-39-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 744E87E851A
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 22:33:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 769CCB20B55
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 21:33:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE5A3C691;
	Fri, 10 Nov 2023 21:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OL3/gDVC"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA20338DC2
	for <live-patching@vger.kernel.org>; Fri, 10 Nov 2023 21:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3250C433C9;
	Fri, 10 Nov 2023 21:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699652000;
	bh=2A5emeoFaW6SfVPuP6ICYHNdvN2k2OlVvkzhivtgSU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OL3/gDVCDj0ENfFBpGtZ814MXkpUyTExFJpMM9gnCGmqHwRSL6tqMC+BSepg4WbAU
	 FyZ6u4MvUFAEsBo7V4hxlY8DUOiwvMtjANO8o76vKvFAcx2WFdMo2CH1gQF0NCkDTA
	 WJkXEzrxa0HqVqjfUu1jkrlgzv+54OoexhAhjv9ZB6e1/JTkpmcBoctBFB3OpuKzQB
	 ezE+C+2l2HFOqd8nZqYw8wuao6Q9qt0VLR0fcmnb0dW2E+U/L/cIl5h2ngQctOfiM6
	 SAEf6LG8sGlbQ5l6/Iez9FXi8OiBvKgUPxj6Ad1m6ssyOl0izyaQSOkLag6fEylZ51
	 dItD/PQB2KwHg==
Date: Fri, 10 Nov 2023 13:33:17 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Petr Mladek <pmladek@suse.com>
Cc: Miroslav Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [POC 0/7] livepatch: Make livepatch states, callbacks, and
 shadow variables work together
Message-ID: <20231110213317.g4wz3j3flj7u2qg2@treble>
References: <20231110170428.6664-1-pmladek@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231110170428.6664-1-pmladek@suse.com>

On Fri, Nov 10, 2023 at 06:04:21PM +0100, Petr Mladek wrote:
> This POC is a material for the discussion "Simplify Livepatch Callbacks,
> Shadow Variables, and States handling" at LPC 2013, see
> https://lpc.events/event/17/contributions/1541/
> 
> It obsoletes the patchset adding the garbage collection of shadow
> variables. This new solution is based on ideas from Nicolai Stange.
> And it should also be in sync with Josh's ideas mentioned into
> the thread about the garbage collection, see
> https://lore.kernel.org/r/20230204235910.4j4ame5ntqogqi7m@treble

Nice!  I like how it brings the "features" together and makes them easy
to use.  This looks like a vast improvement.

Was there a reason to change the naming?  I'm thinking

  setup / enable / disable / release

is less precise than

  pre_patch / post_patch / pre_unpatch / post_unpatch.

Also, I'm thinking "replaced" instead of "obsolete" would be more
consistent with the existing terminology.

For example, in __klp_enable_patch():

	ret = klp_setup_states(patch);
	if (ret)
		goto err;

	if (patch->replace)
		klp_disable_obsolete_states(patch);

it's not immediately clear why "disable obsolete" would be the "replace"
counterpart to "setup".

Similarly, in klp_complete_transition():

	if (klp_transition_patch->replace && klp_target_state == KLP_PATCHED) {
		klp_unpatch_replaced_patches(klp_transition_patch);
		klp_discard_nops(klp_transition_patch);
		klp_release_obsolete_states(klp_transition_patch);
	}

it's a little jarring to have "unpatch replaced" followed by "release
obsolete".

So instead of:

  int  klp_setup_states(struct klp_patch *patch);
  void klp_enable_states(struct klp_patch *patch);
  void klp_disable_states(struct klp_patch *patch);
  void klp_release_states(struct klp_patch *patch);

  void klp_enable_obsolete_states(struct klp_patch *patch);
  void klp_disable_obsolete_states(struct klp_patch *patch);
  void klp_release_obsolete_states(struct klp_patch *patch);

how about something like:

  int  klp_states_pre_patch(void);
  void klp_states_post_patch(void);
  void klp_states_pre_unpatch(void);
  void klp_states_post_unpatch(void);

  void klp_states_post_patch_replaced(void);
  void klp_states_pre_unpatch_replaced(void);
  void klp_states_post_unpatch_replaced(void);

?

(note that passing klp_transition_patch might be optional since state.c
already has visibility to it anyway)

-- 
Josh

