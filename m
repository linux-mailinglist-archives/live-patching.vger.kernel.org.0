Return-Path: <live-patching+bounces-2033-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aDhaFEarlGl7GQIAu9opvQ
	(envelope-from <live-patching+bounces-2033-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 18:54:14 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BCDA914EC50
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 18:54:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7EE91305EE85
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2533E352F8E;
	Tue, 17 Feb 2026 17:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xs3DS/ae"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0291937105D
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 17:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771350786; cv=none; b=EXuYUj5I4g0uWXVdUn3lK3gqs4FY4numC4LUrVd1tXdpC67gBH7vzynWWDQb8S7bVsiTuZvzQo/2pFARNrddBldtvkG5rLG4Kr6iUz6t9RS8fwyJ9C2hJAYnm+NPgeXCHuVuXzn18is/DYnFoQbQmqJmVc30sA8o7JYBEZThmbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771350786; c=relaxed/simple;
	bh=p0W16M7m2arkZQX3SiatrR6BpJ7W0uTky0H98+X8gcI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cxvA8TKt3JlVlodgFjPeTTjXAwoI2QwsJBebx/z8oxzOcThgAwQp1o0cn7jJ2BLp0XPtDpJnBE+e4q5LgksiI+p+uZgRTHM7L6JMP+17DeUPHhH24VGyT9AIPJgdtO81c/s5E+s3g42Ykt1InkIOYIA77nfGXuPRp2tggvB13t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xs3DS/ae; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACB1C4AF09
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 17:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771350785;
	bh=p0W16M7m2arkZQX3SiatrR6BpJ7W0uTky0H98+X8gcI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Xs3DS/aezRQmM20MSBewp2pXT1bRnkN+uvCk/+/aaRcpW5iggVKojvN4rj64isyDL
	 8yMlYJGHaBQzDGUotXg1E2CPpYjFoR7iYeER7YQxsqWP0vsDYWlYjUZILt7t3oKywP
	 zuVQPF4/ogyJiXo03lY+sY/WrG3RxZuLZtnirdInt27+mt2VXfuL97ATtDMXWvM6Gw
	 fz1mNZ09EqM802et3GFRXsV00zg4ChlSgkUhCvPo9TZ6qvs1JtCs1Chk6UQadk+05b
	 CsU7QH9cRegMSaHHKZtmv5SATEan6grZYtBUYnnySu3TobE+Bl1dO/7GQ9XpNEjVZS
	 YjiEUcT/oVPYw==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-896f44dc48dso39350606d6.2
        for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 09:53:05 -0800 (PST)
X-Gm-Message-State: AOJu0YyZf2YGopP35tooR1hT884dT3pbHuToaZBbOLL+O3pkJ2ME1xGd
	3t4q0X5sh6TJlebNI3h2kLBQUfl/gqvhkPzYnVbFGYw3nOVNKYNDxlnsqQRME/VUmU0DDgNtYyq
	ML7hSZZO0PsT9Ce8yGvZ07YbDuZ/9Pc8=
X-Received: by 2002:ad4:5742:0:b0:896:a692:cabe with SMTP id
 6a1803df08f44-897361cd337mr227204276d6.47.1771350784978; Tue, 17 Feb 2026
 09:53:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260217160645.3434685-1-joe.lawrence@redhat.com> <20260217160645.3434685-4-joe.lawrence@redhat.com>
In-Reply-To: <20260217160645.3434685-4-joe.lawrence@redhat.com>
From: Song Liu <song@kernel.org>
Date: Tue, 17 Feb 2026 09:52:53 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4A+vRxi0K6==JJPRkPqXBfJv1BRtG4q+CU5P_1BwHBiw@mail.gmail.com>
X-Gm-Features: AaiRm514kTBsvlfp9BOvmeDlKK80Q22Pf9FGpzF9f7OBwhkxdPuMazi9FUOvWC8
Message-ID: <CAPhsuW4A+vRxi0K6==JJPRkPqXBfJv1BRtG4q+CU5P_1BwHBiw@mail.gmail.com>
Subject: Re: [PATCH v3 03/13] livepatch/klp-build: support patches that
 add/remove files
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2033-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BCDA914EC50
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 8:06=E2=80=AFAM Joe Lawrence <joe.lawrence@redhat.c=
om> wrote:
>
> The klp-build script prepares a clean patch by populating two temporary
> directories ('a' and 'b') with source files and diffing the result.
> However, this process fails when a patch introduces a new source file,
> as the script attempts to copy files that do not yet exist in the
> original source tree.  Likewise, it fails when a patch removes a source
> file and the script attempts to copy a file that no longer exists.
>
> Refactor the file-gathering logic to distinguish between original input
> files and patched output files:
>
> - Split get_patch_files() into get_patch_input_files() and
>   get_patch_output_files() to identify which files exist before and
>   after patch application.
> - Filter out "/dev/null" from both to handle file creation/deletion.
> - Update refresh_patch() to only copy existing input files to the 'a'
>   directory and the resulting output files to the 'b' directory.
>
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>

Acked-by: Song Liu <song@kernel.org>

