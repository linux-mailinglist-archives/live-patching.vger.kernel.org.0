Return-Path: <live-patching+bounces-1740-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 94198BCB2EC
	for <lists+live-patching@lfdr.de>; Fri, 10 Oct 2025 01:19:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29CAD426ADA
	for <lists+live-patching@lfdr.de>; Thu,  9 Oct 2025 23:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F62122B5AC;
	Thu,  9 Oct 2025 23:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bQKhbVlC"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F9084039;
	Thu,  9 Oct 2025 23:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760051950; cv=none; b=lHZ4gnNzK+9oy7XZ3rmeE/a3hyRNfeeQcELD3LhfP4wIRlmw5MTm5p5En2zWNWM6LM+f+v74G/LMH5dkGq55VUbiG/4WdHPxeseOGTE4vlMPeibmD1pvH7PspBYjWBUs/nC56YLgrcAvYf92kejWRN5gxHluLYBVHEEKu2h7Mto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760051950; c=relaxed/simple;
	bh=1PvGWVYr9vfvh2L79u5bLC0Cz+FKXrJZ/YdguE3JS6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QLBPQD1QKSsLjdrWJeEbRpDdAidIClH77PpwjYoN656An3ZsiLtAAkmbTfj8uYKaybSVruERYufnf1eDLLmaQjZCuE+70NnCD/fmWR/GIeduyYBQTRxKf4bl0zl4uWpzxhIkUh8u9UIH3jb54GieOd12pLh03zvo5WJ9iSHCEEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bQKhbVlC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FD9C4CEE7;
	Thu,  9 Oct 2025 23:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760051948;
	bh=1PvGWVYr9vfvh2L79u5bLC0Cz+FKXrJZ/YdguE3JS6E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bQKhbVlClpMcx0bGSFNCJp0YkuEenL52jEEcsJN/ctSxsr7Nl7MnWLCePlTRAbjCM
	 Luxkxo/JNQmEk4hAgUr1HjcsZGMr6uTTJbFm8PyLU33WjD8HHnp3P6b+nY+aJ9FreY
	 EEKDxKthMeU5mlFDTUSHPFGcXsE9xNIdbrURugvbXKqgDiyl61PWlE6VBVjnmyFK3A
	 X5gN9kCr55PI2MYYqF2loVXUGMRLBimGtyoZwu2vz8dMR/+bAgGT6S842FSO30bSvN
	 rV0H6awiBwq2q9is197xoJQwLesHuaFRixWHO4aD1U/BrsFuOOX4I4b0Yz9cMZMvo/
	 CM1dBdJjJ96lw==
Date: Thu, 9 Oct 2025 16:19:05 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Petr Mladek <pmladek@suse.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Miroslav Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>, 
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, 
	Jiri Kosina <jikos@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>, 
	Weinan Liu <wnliu@google.com>, Fazla Mehrab <a.mehrab@bytedance.com>, 
	Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Dylan Hatch <dylanbhatch@google.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 51/63] objtool/klp: Introduce klp diff subcommand for
 diffing object files
Message-ID: <xwbop4e2f3pcyjk22v5r6aufy2dvlwhgaxthfis6iw3mra7e53@x4r6b3qwomp4>
References: <cover.1758067942.git.jpoimboe@kernel.org>
 <702078edac02ecf79f869575f06c5b2dba8cd768.1758067943.git.jpoimboe@kernel.org>
 <aOZuzj0vhKPF1bcW@pathway.suse.cz>
 <bnipx2pvsyxcd27uhxw5rr5yugm7iuint6rg3lzt3hdm7vkeue@g3wzb7kyr5da>
 <aOeqt32wQhB5jAD-@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aOeqt32wQhB5jAD-@pathway.suse.cz>

On Thu, Oct 09, 2025 at 02:29:43PM +0200, Petr Mladek wrote:
> Sounds reasonable and I am fine with it. I have one more question
> before I give my ack ;-)
> 
> I wonder about the patchset which better integrate callbacks with shadow
> variables and state API, see
> https://lore.kernel.org/r/20250115082431.5550-1-pmladek@suse.com
> 
> I think that it should not be that big problem to update it on top
> of this patchset. It would require:
> 
>    + moving declarations from livepatch.h to livepatch_external.h
>    + updating the macros in livepatch_helpers.h
>    + update callback-related code in create_klp_sections()
> 
> Or do you expect bigger problems, please?

Yeah, that should be pretty straightforward.  I can help with that.

Right now there's not even a way to create a klp_state.  (not sure if
anybody's actually using that feature today?)

For your patch set we can add a macro to livepatch_helpers.h for adding
a state (and its callbacks).  And then corresponding code in
create_klp_sections() as you mentioned, and a small change to
scripts/livepatch/init.c to set the klp_patch.states pointer.

-- 
Josh

