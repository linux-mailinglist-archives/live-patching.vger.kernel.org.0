Return-Path: <live-patching+bounces-2039-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kIP0FSO4lGlmHQIAu9opvQ
	(envelope-from <live-patching+bounces-2039-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 19:49:07 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A6F0914F555
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 19:49:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7B13C305E9A2
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 18:45:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A973372B54;
	Tue, 17 Feb 2026 18:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ITfzDlYi"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D6D29AB00
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 18:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771353959; cv=none; b=JwvimBOWhNzOlEOEZ5fjQv6cqV3tPbLdpiT/tkJsCslLVMCYFSHne5kdAvCRlg9bHwWB4pHkOV6B1EbHUSOTWDnihD7QvxoKYDuuGIDDoSiEFSEZmkjxzpzf/6xWDsn4X3uKw2E6B3ixyCFQyAy+hpAL0iejV9uHrDsMR9Tpc+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771353959; c=relaxed/simple;
	bh=kNxzKoPNRCke7AS5KrODXvgKb2igsffOXA4+rh9pAH0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kBDnQrxD73ylDGcOJBqam5zLOg1+kriwE8NFx6WIBBsJ2HWdQqX2Dx7CFMSpW7R+kJ2cq/l2N0ryyF0918roSdI9ae5MG52e5wSXPG06OljARoSnIVlFdC9OOHxSvuyvlsghgvz8arhk/urujNA9Ruh/trqNFU/qw2Zi8d760HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ITfzDlYi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE71C4CEF7
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 18:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771353958;
	bh=kNxzKoPNRCke7AS5KrODXvgKb2igsffOXA4+rh9pAH0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ITfzDlYiMpnXIOexz0ve6XmdaGcHKkRELM7TBuaGdEv7v0ph0qv8dUeQlwKe4KtJP
	 s02F+C8/gtsBCXISYOgdrK8pJxtQkX1tSA0ikrA7MvFlHpUy8yN11f4D3lewPagM1+
	 qfwtPME0PyAUQ/qJCb2634DL3N4IAql7nDuLXtOJ7q+yxVQc+sawnmmvXIeqE5Cwzu
	 3s7hOx60bi3jR/2JQy8bUiPnfpv1RGqo8e5TwUzkNNvnUSXfL+3N6z+5qyrevxas0c
	 0AAlozJH6TBzf6mXYJNpYwjbJ0ILPFqz+I5YkpmRzbEpvuwR6PpyMpEi1DihNHKmFs
	 /yXp7VvSnU3Rw==
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-50698970941so51400641cf.0
        for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 10:45:58 -0800 (PST)
X-Gm-Message-State: AOJu0YwdI69wI10IYKn1tj01jkBnxXGBFatbbU5k3M0oSah5vEfLSJO3
	EnOcdBmUMoVok2GBo6BOQIPegwYow9MKpl4oUGljnGtR7vP5arpqI23cvGQj9rZ+IS6MPA6K/QV
	dl1/VIPBvDOszvsj3MjjUJtMVhLbAOBw=
X-Received: by 2002:a05:622a:1654:b0:501:5284:c49b with SMTP id
 d75a77b69052e-506b400153bmr145569541cf.39.1771353957878; Tue, 17 Feb 2026
 10:45:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260217160645.3434685-1-joe.lawrence@redhat.com> <20260217160645.3434685-12-joe.lawrence@redhat.com>
In-Reply-To: <20260217160645.3434685-12-joe.lawrence@redhat.com>
From: Song Liu <song@kernel.org>
Date: Tue, 17 Feb 2026 10:45:45 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5rZ3o_mXoSsbLohKL-qxdVoSbYadh3Y91jTtY_SjNsMw@mail.gmail.com>
X-Gm-Features: AaiRm50_9sTsE-_WRQDZ1UItF1jxBt0_Mbj3wD3L6XWxbpVQc4aWPZ1A5jDtEnk
Message-ID: <CAPhsuW5rZ3o_mXoSsbLohKL-qxdVoSbYadh3Y91jTtY_SjNsMw@mail.gmail.com>
Subject: Re: [PATCH v3 11/13] livepatch/klp-build: add terminal color output
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2039-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: A6F0914F555
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 8:07=E2=80=AFAM Joe Lawrence <joe.lawrence@redhat.c=
om> wrote:
>
> Improve the readability of klp-build output by implementing a basic
> color scheme.  When the standard output and error are connected to a
> terminal, highlight status messages in bold, warnings in yellow, and
> errors in red.
>
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>

Acked-by: Song Liu <song@kernel.org>

