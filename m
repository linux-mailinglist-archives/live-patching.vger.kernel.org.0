Return-Path: <live-patching+bounces-1783-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D61E7BF6FE7
	for <lists+live-patching@lfdr.de>; Tue, 21 Oct 2025 16:12:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4731518882F9
	for <lists+live-patching@lfdr.de>; Tue, 21 Oct 2025 14:10:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5C6830BB83;
	Tue, 21 Oct 2025 14:09:40 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3801032B99A
	for <live-patching@vger.kernel.org>; Tue, 21 Oct 2025 14:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761055780; cv=none; b=uHej3/lJZEKgWgn8LH4m2K+s2T3C4MCiuWNJvFIDiFwqpa9Cd/JdyRl6m+O8zMdOwGn65ek658CCZY27nPxSSNqzLh+xmkiummnkrJSR9q7JdE0Rk9Zxjrha+aD7U0D4NzPzdvX+pNtQ4kEf0OQBoiJpmkE4+8GVygo289t/XA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761055780; c=relaxed/simple;
	bh=nn4lvCL6rsCBNVQSCXc+sUXA+7J/EistXykFldeyHWk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OMOTRRA4LR0rBVed7fptr9nFx3GElj5F9bG1c7snOMbeZ574nkcxPx1KRfT1GdGlvTwjhGPp5cFdqWay9PLr21oJJIbPWzgmO1byTLFeWETKpliJhdX0wc8wVHqWt8TPdVKyXXjLfc6nNCBEggMdVr8D1J4zzQCwy92+nhhveVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C7856593B6;
	Tue, 21 Oct 2025 14:09:36 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf18.hostedemail.com (Postfix) with ESMTPA id 02DFE30;
	Tue, 21 Oct 2025 14:09:34 +0000 (UTC)
Date: Tue, 21 Oct 2025 10:09:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Song Liu <song@kernel.org>
Cc: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>, Petr Mladek
 <pmladek@suse.com>, "kernel-team@lists.ubuntu.com"
 <kernel-team@lists.ubuntu.com>, "live-patching@vger.kernel.org"
 <live-patching@vger.kernel.org>
Subject: Re: [External] Re: Question - Livepatch/Kprobe Coexistence on
 Ftrace-enabled Functions (Ubuntu kernel based on Linux stable 5.15.30)
Message-ID: <20251021100956.4c64272c@gandalf.local.home>
In-Reply-To: <CAHzjS_vD1TJkVxN+bf+2srKhH9ajn=BHyvEn7oeu664R481R+g@mail.gmail.com>
References: <c5058315a39d4615b333e485893345be@crowdstrike.com>
	<aPDPYIA4_mpo-OZS@pathway.suse.cz>
	<CAHzjS_v2HfpH1Oof3BWawN51WVM_1V1uXro4MSC=0YmMiqVWcg@mail.gmail.com>
	<82eaaada-f3fc-44f7-826d-8de47ce9fd39@crowdstrike.com>
	<CAHzjS_s2RhM3_H9CCedud3zkGUWW2xkmvxvPLR1qujLZRhgL1A@mail.gmail.com>
	<CAHzjS_sQQaTZpxC2drGx8=7zCMAKQN_CNjYFcNzxZEGhd+yXPA@mail.gmail.com>
	<69339fb8-04a6-4c28-bb71-d9522ebd7282@crowdstrike.com>
	<CAHzjS_tf0KeBnzA6psjHSCuiXn--hK=owDPhCPUB0=jnLDBk=A@mail.gmail.com>
	<4cc825e6-fdf8-4fc1-8ccd-9bad456c2131@crowdstrike.com>
	<CAHzjS_soRQwKKP24DObNKBnOtiNsVZHOM-NnY_34w5GwGhC9rw@mail.gmail.com>
	<5477a73a-1dce-4b9e-b389-e757ef5536c4@crowdstrike.com>
	<CAHzjS_tuotYQQ0HmncVp=oFOfcyxmYqCds0MDBMOr5FC5KzhSA@mail.gmail.com>
	<7e6886ab-b168-422e-9adf-8297b88643d1@crowdstrike.com>
	<f3f3e753-1014-4fb2-9d6e-328b33c7356f@crowdstrike.com>
	<07ab2111-0f41-40cb-aeb1-d9d3463b1a6a@crowdstrike.com>
	<CAHzjS_vD1TJkVxN+bf+2srKhH9ajn=BHyvEn7oeu664R481R+g@mail.gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tn1s1wmexhzepz9hjg8fad4cp9e4jor4
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 02DFE30
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19WPT6fRrcbnXNzwNXuOeat+ywiNnkYs6Y=
X-HE-Tag: 1761055774-947347
X-HE-Meta: U2FsdGVkX1/XExwIpLQ25yzuu2yl1a41RC4tKmOZOOj0oYZ90/TjlX6paBkKgx2UdN5aSqBis/mjpsQaN/odYkTmMTPfB+cbDJEPYE906QIgowS3t2mTLRLtWa9dD6EA5ns3hUnlhjy96wxB0eTQnaUq1MUmUARUFEsPgiuLROOcpbIlwa1h//nRXXLd8ux5TX6/+AuKA6DaaiPfnUBWs614BF5xgZoDY/EA1jdB5eIlhOzCkY/vAbBlmWjfDzr/HI2Jj8C3VUm0F4IfEa0caoOSFBUFNwxz0srRuzoTN3r67XR4Fgp+mzjA8rxltNjAwCRVEjk8uRKT7elzs6TqkvSZD/M+e+7z5zvWMB+j6mTmvWAjvtEUig==

On Mon, 20 Oct 2025 23:07:26 -0700
Song Liu <song@kernel.org> wrote:

> commit a8b9cf62ade1bf17261a979fc97e40c2d7842353
> Author: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> Date: 1 year, 9 months ago
> ftrace: Fix DIRECT_CALLS to use SAVE_REGS by default

Hmm, this is a work around. I wonder if we can make this work with ARGS as
well? Hmm. I'll have to take a look when I get a chance.

-- Steve

