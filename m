Return-Path: <live-patching+bounces-2183-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4AFdEUDrsWmSHAAAu9opvQ
	(envelope-from <live-patching+bounces-2183-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 11 Mar 2026 23:22:56 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B52926ADCF
	for <lists+live-patching@lfdr.de>; Wed, 11 Mar 2026 23:22:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 77547303C028
	for <lists+live-patching@lfdr.de>; Wed, 11 Mar 2026 22:22:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E5EB386543;
	Wed, 11 Mar 2026 22:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PqqFvIaZ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B90F33DEF3
	for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 22:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773267763; cv=none; b=mrkRF+KLFMlZeJ0flnAF/sbtk5F9lo8bGeJgr6CdoOwyqg7KjLxZyJ/FFYoSsciAhlxw8lrA6Qwd30BwcaFg2V588W/+YlNDobCDunoCXdO9EyxNFxozM7dvBRLT9Lem5J1vYrzSQ2aEJWg3/d8eMpCkzIz+GRDoyrdTSgvRy3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773267763; c=relaxed/simple;
	bh=nnSNfQt+gvV9VYFp5kgal+ChmLUgi6djrHf4PSTVRTs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=msoiHD0HxNGyEjSYV3/e3JQbN0fOiRIWjo8I52Z+3ctBo+gzpjd9KNLSF2DBlARtTi2P5JscKCYVml84UAOqtgGo2xieUIYmO3+IHRhKQqacS/Gd1v2AxDFIoZHoEVq9daggPtnfoYJX73n22QZzXnoIjhPrrHD4ktXdO7tpGa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PqqFvIaZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A17C19425
	for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 22:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773267762;
	bh=nnSNfQt+gvV9VYFp5kgal+ChmLUgi6djrHf4PSTVRTs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PqqFvIaZQuySMrqM9U2lzjf1bvct+HMEh/32n54zTp1oIy0le9Ssk1MSyn0DvG3Eq
	 mKCuAJluoJodFBAbnC2PDVskZkbtfhtavWqONt6GTKuHDdi6x7bogg3fzZkyCFGaRU
	 ZS4WegcgBaEwqvDcWxo3qRhGvv3IEJ3uXu/jCOX535rwqCT9ZUPL5qpv73CvLYmEe4
	 kLdvc7KqcsSDWkW2Dm5qfFAB7P4g2cas8CiueMSG0o8uLmCDi4zvimwXLoLicds8bI
	 bw0wXGbuWU4y9B2khFtKYZowe9JIpd+AqyCW5R7j1dQyO6WofWPK/fsqjYyG+87Uyv
	 S5VBflfdjnOFA==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8cd8d97aa2eso42572285a.3
        for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 15:22:42 -0700 (PDT)
X-Gm-Message-State: AOJu0YyglesagOXErnQyRQot/6bWA4IRcfxx52RYbwZ0sSK9T0F0aUOe
	JY/8utjoDJaPCn3BGR+xpx4d8QsoDPIbMiQfhJz/1OBTDOostz8dXzpqhQCchnjUfcATOzR6GO6
	x6U2lHGgpPqn1eK9XGW0Ebe9cVZfdPRo=
X-Received: by 2002:a05:620a:46a8:b0:8c9:ea1c:f218 with SMTP id
 af79cd13be357-8cda19ba4e2mr533912785a.15.1773267761890; Wed, 11 Mar 2026
 15:22:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310203751.1479229-1-joe.lawrence@redhat.com> <20260310203751.1479229-13-joe.lawrence@redhat.com>
In-Reply-To: <20260310203751.1479229-13-joe.lawrence@redhat.com>
From: Song Liu <song@kernel.org>
Date: Wed, 11 Mar 2026 15:22:30 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5a7EmcF6WMss8Hso746RPQ5S6x2gGBQQkKzHu=Fc8AXw@mail.gmail.com>
X-Gm-Features: AaiRm51cx0qe-GJOuF_cmc-Pa1Yt5ePhepI1lcvuORTFwlG1TZoXOJhhnuT_LKU
Message-ID: <CAPhsuW5a7EmcF6WMss8Hso746RPQ5S6x2gGBQQkKzHu=Fc8AXw@mail.gmail.com>
Subject: Re: [PATCH v4 12/12] livepatch/klp-build: report patch validation fuzz
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2183-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 9B52926ADCF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Mar 10, 2026 at 1:38=E2=80=AFPM Joe Lawrence <joe.lawrence@redhat.c=
om> wrote:
>
> Capture the output of the patch command to detect when a patch applies
> with fuzz or line offsets.
>
> If such "fuzz" is detected during the validation phase, warn the user
> and display the details.  This helps identify input patches that may
> need refreshing against the target source tree.
>
> Ensure that internal patch operations (such as those in refresh_patch or
> during the final build phase) can still run quietly.
>
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>

Acked-by: Song Liu <song@kernel.org>

