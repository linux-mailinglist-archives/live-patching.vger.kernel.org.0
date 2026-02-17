Return-Path: <live-patching+bounces-2035-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eG9uLJyzlGlbGgIAu9opvQ
	(envelope-from <live-patching+bounces-2035-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 19:29:48 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C03B14F23F
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 19:29:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CE7F330063B8
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 18:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54E6C36F420;
	Tue, 17 Feb 2026 18:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ojGEOHrs"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AC636E49A
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 18:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771352793; cv=none; b=pml98VfBI/ylUa8zh2akSj3oHlaSZnPMNUcGycLXCPw41GqKJkjhtOXPjnacNOLhpstAhvb8uLJ6ToVVrwA04EpVTSd2KztR1lTvLcPx6aT4xsZbL1oEhd/TvEzkHLGACfZfMIMQBZKU9tMTA+l6ExYygSne/+QkdGx9yj0lyYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771352793; c=relaxed/simple;
	bh=PQDQgHzTnPbSPyVTBEsNFSmLLSIAJYYB6qlnLjhDqFs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O6J5IMlf3hAxj8xHOS6873fc/lPPB2m4Mb2dsWP/OJQLHmV5ZgcddNUKABkYgugjNST501NM2j50MmJ9HWEU+zEiPe6tZMUbbYzhSEf2aYhE78b98rirMjwYG9m9ioi9utDI4IEle2FDJHIyx90mpOE2Bg7H8IK7sLP9O0X62Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ojGEOHrs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3270C19425
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 18:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771352792;
	bh=PQDQgHzTnPbSPyVTBEsNFSmLLSIAJYYB6qlnLjhDqFs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ojGEOHrsnjC9l7ZRIULtDRrUI4VVV55lAsH6WyJpc6UozDHbbDxZPd9NZDBMgpvUN
	 gEqq3jsa4i+o8LoKXJTaHD27xmd2rMNhGl0Us5xoieJAkLvw5XXVmzkoKVE5PFYoAF
	 cmPxS6D49DOKPi8PlxBWFnkS1Ka6fKFXM6/rcnM6EogtX44pQAU6jPT0GHBqckiTqO
	 ewO0sr8b2fmObS7vpjbqJ6qU4lZBrjRN+BID1DWSgnLY7NM6CQ2s+gM2vYY7kKkIMW
	 TB3QfpxFAXfsCyZ8yQumMBwfniPgz/I3JPTRRU8P6yA+fyzJYhyoLhPwYudhNxu58m
	 JdLFIxQScA6TQ==
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-896fcfc591eso44408636d6.2
        for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 10:26:32 -0800 (PST)
X-Gm-Message-State: AOJu0Yx4pGQ3v4RPWubs0OPVp171R/cvON/mPD0d1q7GPH+eqU4lNG/9
	rQzgVZ1K3Ti/x0H1R5gDqOQXScBI96ruHQQGOdK1Z7qnacWp8WmTl95vNEDPSoBoP+grSUnaHdC
	kKGd7KhzyswoXmuFevIuyKxSCLuOFZpI=
X-Received: by 2002:ad4:4ee4:0:b0:896:f320:b18c with SMTP id
 6a1803df08f44-89734881468mr232374396d6.6.1771352791927; Tue, 17 Feb 2026
 10:26:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260217160645.3434685-1-joe.lawrence@redhat.com> <20260217160645.3434685-7-joe.lawrence@redhat.com>
In-Reply-To: <20260217160645.3434685-7-joe.lawrence@redhat.com>
From: Song Liu <song@kernel.org>
Date: Tue, 17 Feb 2026 10:26:19 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7f5LmWSE1DQ1-ncwPE1Cx7j6EzC9pp+K1ijq-+cJopug@mail.gmail.com>
X-Gm-Features: AaiRm50_utqz2pjv8FvIXH4cjtBb5PZvZr3V-aE0hk-KY2qVPsmXJ2CNon-r74o
Message-ID: <CAPhsuW7f5LmWSE1DQ1-ncwPE1Cx7j6EzC9pp+K1ijq-+cJopug@mail.gmail.com>
Subject: Re: [PATCH v3 06/13] livepatch/klp-build: add Makefile with check target
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2035-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4C03B14F23F
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 8:07=E2=80=AFAM Joe Lawrence <joe.lawrence@redhat.c=
om> wrote:
>
> Add a standalone Makefile with a 'check' target that runs static code
> analysis (shellcheck) on the klp-build script(s).  This is intended
> strictly as a development aid.
>
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>

I wonder whether we can add logic to "make check" to replace the
grep-override function. But I guess the override function is OK.

Acked-by: Song Liu <song@kernel.org>

