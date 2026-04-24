Return-Path: <live-patching+bounces-2530-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UPyeLe7i62kySgAAu9opvQ
	(envelope-from <live-patching+bounces-2530-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:38:54 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6228F4638A4
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BE17030066A3
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 21:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C89742BFC8F;
	Fri, 24 Apr 2026 21:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aD6+ZYjj"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EA21DA62E
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777066732; cv=none; b=PdMri1WINxQZta/IScmydyMmh5rsWcz37+ipQIqWHR1EuFHy8iMe3UxD9W/0TAS3G76OBEW6I7A6cNjeA9ubYXZPyk14xseLdr3+urwgIW8IpqOTzIsP30BKMeO4OudU7brNhFA5ZqB70qYxY+K99STq0P1aZkInPa9rzuhRtfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777066732; c=relaxed/simple;
	bh=FE/x8YwSfyYHiA5vjdjr11P5OXfLVPzyInkskdPVsOk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZuM2RFuVSD2woXKr1lXpMHKjQ6d5RE1pZXHfzr3MvmAkhg1pNFjAmXHTjJhYxAaD9tfnZ1P/XVeJv9D6STrzDGy1ZR+hDvWIO1Ie5FGZ4R61l61hY3TELAHWMSvLtt2H6ijC7xa2YZIsuYX/ZXJSYL4diKYQj88Gr5OIfiUn+VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aD6+ZYjj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835F6C4AF0B
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777066732;
	bh=FE/x8YwSfyYHiA5vjdjr11P5OXfLVPzyInkskdPVsOk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aD6+ZYjj3JdrsxMW6uTrnLYc0F9addVvxTi3gNU64pbO7homKhBvx8yRwyJZXG0Lx
	 D0kYwreOEKb96rD975WGvhRnBBvrgJDq3N45adI1Rd4/xGJzU14wld4rZQ3W+b5J86
	 fdqnaxsrBWOpZmIIo68ApU1oX6fnKabL+ceAOL2zi2R8fj2ped8nteQU5aquQIgEJQ
	 Yqw3dB49SmdUsGzD7UgCLZP5q8y0QBvFNZTMaPKaknIk6U4UlH9fzheVbc2wTDFzu8
	 qKfb18dc39ZM2+BIiE6FXmTftXuKdBJ4InZErVscItT8AsXBcMz3mDZfNjyLhJhcOz
	 +lSC/2SX73kMQ==
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8a3970f1a0eso91607196d6.2
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 14:38:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/4JOf6ZkWN/DhRMKCO/35oKF0nrktvhOekXK2pe/b37LcRGjHVG5PMYyXPnsgRjlurSQMN9hPoiGJJ/ghp@vger.kernel.org
X-Gm-Message-State: AOJu0Yzfa3skQhvf12repxMhp0XVKCRwjFLCYHJUlypm6MrTHSeKkJS6
	l9RJzkriZp2Ix5hb+Ohp41NhH0aPElNDjOHpTnNPH8t4FW5mFtq7eEAHWSPFWntfZek/8MJ6BAW
	N2QlZAvK0dQw3byc+2peir6HiU/HQ1og=
X-Received: by 2002:a05:6214:2f03:b0:8ac:af0d:c101 with SMTP id
 6a1803df08f44-8b027fd9d3fmr511901066d6.10.1777066731752; Fri, 24 Apr 2026
 14:38:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <2022e064d670290bfc4ce96207c64b2282d39959.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <2022e064d670290bfc4ce96207c64b2282d39959.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 14:38:40 -0700
X-Gmail-Original-Message-ID: <CAPhsuW74HwZLkcb=zsuCzc8oNMupEX=PCJ-nmGtBHN_G7QNgqg@mail.gmail.com>
X-Gm-Features: AQROBzDdQY4cna3aLxjnnRSE3OMvH-oYmmJanMvIoEvpe6NfEleppECws4Nc0Z4
Message-ID: <CAPhsuW74HwZLkcb=zsuCzc8oNMupEX=PCJ-nmGtBHN_G7QNgqg@mail.gmail.com>
Subject: Re: [PATCH 15/48] objtool/klp: Fix kCFI trap handling
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6228F4638A4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2530-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid]

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> .kcfi_traps contains references to kCFI trap instruction locations.
> When a KCFI type check fails at an indirect call, the trap handler looks
> up the faulting address in this section.
>
> Add it to the special sections list so the entries get extracted for the
> changed functions they reference.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

