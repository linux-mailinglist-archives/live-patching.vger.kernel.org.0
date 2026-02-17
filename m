Return-Path: <live-patching+bounces-2036-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wGabGp2zlGlbGgIAu9opvQ
	(envelope-from <live-patching+bounces-2036-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 19:29:49 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CD82414F246
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 19:29:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CCAFE300E613
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 18:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B61E4372B44;
	Tue, 17 Feb 2026 18:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ig5xCy4/"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9075A372B3B
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 18:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771352986; cv=none; b=cOogCrG8ZzW4A2mAemA4YloAxWqb0HGHlOo4TOpJJqwgbVmY4OVs62cER6V8tKOJp+BnrMxVrh4PyxDOAKols0VlLMkUmTB5TMT+WHL94sTy8ZRAEFHQ3eREgPIyzBVB6QN4QlnEYSoDQQAUbk7MDIlSk7bnjOrTsPhEb1V5oY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771352986; c=relaxed/simple;
	bh=wIP9vQQuRqjMOU8netW3ojLA4Hea6DWMZLNsBmwWVyU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZxtiEzzfXfYg+d+a9kgCJ4dyB++XF3fqOuf0g4lTpC5aymrGCXRZPT0zc7SINHojtrT+RC42lelkh3xMcAoozzSmSsDFn8BaHzXjQb+qy3I4qMbsSf6JLxPJ11rl9GfxizNU3jg+EX25/v7U4/wED6e8bB+tMUm5zElEzQV9z6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ig5xCy4/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FFEC4AF0B
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 18:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771352986;
	bh=wIP9vQQuRqjMOU8netW3ojLA4Hea6DWMZLNsBmwWVyU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Ig5xCy4/MvyCU0GJUCQ4yaxHDXOJKq79o5SthQHwQfmkDCw2DQOyDoQONeUMCqS79
	 Rgv074JQZGy3Le8n9UnSw84mTFah71siB9QXrIufNEe9XbiAgZ3LkmFqPlCv38hLo9
	 hJm1ULYtqkaGgRBwufWEhV95ifpEK27Z9/eTXQsdrkXdUwRVEQSi3Kee7ZYJT26mK+
	 1eK1Hn5JDQs/jTbs3Di1WvhXbgVH8lxhGKvopvMPBYaQoX4wG4BuCs7bpbRdrG5YKw
	 DV83xBLES6j5lCqqTomvf+QDrruzPSoxJMKmK8ItwSZA4lomHs7VsK1BtgxIY/3TsI
	 e4b4BnjQ51PjA==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-896f95e07f5so40995696d6.3
        for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 10:29:46 -0800 (PST)
X-Gm-Message-State: AOJu0YwAINOABHCKR1qsjO3GXFGqjSXd8unfydLAVp/9KvBuAM9T7bhR
	wl8/DxqNbXOvG30xAE2Iq2R/D8AGV5UIkg/fL33TizrCCHDu6PUK3KTMgUccbO7phvJ/QK+4vOj
	QmKgYZKmGWCDA7qwIv8MO5vdjR2FrgHo=
X-Received: by 2002:a05:6214:f24:b0:896:f95e:65d with SMTP id
 6a1803df08f44-89736093799mr202333506d6.17.1771352985322; Tue, 17 Feb 2026
 10:29:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260217160645.3434685-1-joe.lawrence@redhat.com> <20260217160645.3434685-9-joe.lawrence@redhat.com>
In-Reply-To: <20260217160645.3434685-9-joe.lawrence@redhat.com>
From: Song Liu <song@kernel.org>
Date: Tue, 17 Feb 2026 10:29:33 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4oRf1OY9Jmxt5YM+i51nVYEq5hgQ1m+Ed7tMc2w58gmw@mail.gmail.com>
X-Gm-Features: AaiRm50HEY7Puiaw8FQt2bTntFi1WACM2oXjRzxcY9JkdJsxEDm4VwwuSugX-DE
Message-ID: <CAPhsuW4oRf1OY9Jmxt5YM+i51nVYEq5hgQ1m+Ed7tMc2w58gmw@mail.gmail.com>
Subject: Re: [PATCH v3 08/13] livepatch/klp-build: improve short-circuit validation
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2036-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: CD82414F246
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 8:07=E2=80=AFAM Joe Lawrence <joe.lawrence@redhat.c=
om> wrote:
>
> Update SHORT_CIRCUIT behavior to better handle patch validation and
> argument processing in later klp-build steps.
>
> Perform patch validation for both step 1 (building original kernel) and
> step 2 (building patched kernel) to ensure patches are verified before
> any compilation occurs.
>
> Additionally, allow the user to omit input patches when skipping past
> step 2.

Nit: It may make sense to split this into two patches.

> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>

Acked-by: Song Liu <song@kernel.org>

