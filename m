Return-Path: <live-patching+bounces-2682-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cCmdD+aD9Gn8BwIAu9opvQ
	(envelope-from <live-patching+bounces-2682-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:43:50 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C65BE4ABB87
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:43:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8264430058C7
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 10:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FFBD388E42;
	Fri,  1 May 2026 10:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a8rkYAqY"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBF738759A
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777632225; cv=none; b=pMsWo057XI5C51OB2D6YJlnO4n3R0PDF3/epQnu9SEu2pw5eoi18bxofQw2yw8hSRjUr/9nbw8NCjz4e59x5fhs7MdIuxwhIMWofV/F8kEp35ls61Ua4NVEw6gHgtZ7HPv/uSi0lTmmV6cglFfLnK/vNWo1MP1S92GETPmgcuPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777632225; c=relaxed/simple;
	bh=qfq5CO0bHl1vY4CKIgR+W1JcOwV15aUlWqr1ppe0MKA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dAmV88XPTk+QsHRdQnFqoiLcx/6K+LN9AWnISkVuuqq42e+KmBtl+NxuHxUwJ1TVudHshXQx7dC6roR0LQ/OoFvr29SfGnjhaXl4z6HrVYmu61ki1/9XRS5VMDcLeM+VhrN7h2xu2E1zqcG3z7ydMMyyCBS+0H4UBFle6tAldZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a8rkYAqY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE69C4AF0C
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777632225;
	bh=qfq5CO0bHl1vY4CKIgR+W1JcOwV15aUlWqr1ppe0MKA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=a8rkYAqYJSLdGdzzFU4W0kfWrUfzdu7dZUp8lIkY6ivq44Yfm4jF1/jaGVsfM2oqs
	 dx/jvsHkWPA5GJGIV83GE2YRbVPBQ8U5rTnC4hugQq7oMbfRdZwZ69iOb6/sx3KU7g
	 buP6LwhqHJx3LEpn01N64Tvvxfs97bjlH0LWoTiFoKa7XySs5nIRaVHDWMYxIWgkUC
	 v7iT0waNuhs3E4n+L6iPm3jtRFmn66kloCIYZzGwnCJzUO38iQhrdfDPdLL4f1Dhz4
	 BuEEdo2TT5R6Ie/ts7HHXdlmeQkY1w+a4zFDIYyUxqqso9VBA225UhTmIHDBbZ3+rK
	 ihepkIcYPGQmA==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8cb5c9ba82bso284991685a.2
        for <live-patching@vger.kernel.org>; Fri, 01 May 2026 03:43:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9eHtRIhAr3/nfm972yqHli53rK5mUy+7XwT82nmsHjPDSum3ah18I03QsbdKqhWFWrGTRzPSwjxS+uAUGO@vger.kernel.org
X-Gm-Message-State: AOJu0YwTOO/28gIiLAPxjTnbNRglBrDWqzuqIxLs6gTaTGp438AI+CHL
	8hH/5AHArZJRFeso+rKxY70JVIhPQS/wNwkYNc2rCu6/9Qj7oae8iP7f7k9MIg9isvhSJAfwOAe
	rPiozd1RclD2NNfR0XcmRHuvz7rVBqeg=
X-Received: by 2002:a05:620a:1786:b0:8cd:b52c:598f with SMTP id
 af79cd13be357-8fa89a074d0mr1021265985a.59.1777632224262; Fri, 01 May 2026
 03:43:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777575752.git.jpoimboe@kernel.org> <a84513224f38c7c7ca2cf2a4930f87d43a76908b.1777575752.git.jpoimboe@kernel.org>
In-Reply-To: <a84513224f38c7c7ca2cf2a4930f87d43a76908b.1777575752.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 1 May 2026 11:43:31 +0100
X-Gmail-Original-Message-ID: <CAPhsuW4k7cnzVHfz3QrXgud5R6vxBC9=wY2OeAB7+V-BsNTWKQ@mail.gmail.com>
X-Gm-Features: AVHnY4Jzl6LjIA2TdFxwXi1tIFiNk6RWzrkcgcpdkeJUfXZnSJgONzpqv7nZ57M
Message-ID: <CAPhsuW4k7cnzVHfz3QrXgud5R6vxBC9=wY2OeAB7+V-BsNTWKQ@mail.gmail.com>
Subject: Re: [PATCH v2 38/53] objtool: Add is_cold_func() helper
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C65BE4ABB87
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
	TAGGED_FROM(0.00)[bounces-2682-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]

On Fri, May 1, 2026 at 5:11=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> Add an is_cold_func() helper.  No functional changes intended.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

