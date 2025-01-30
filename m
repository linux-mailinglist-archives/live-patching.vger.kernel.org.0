Return-Path: <live-patching+bounces-1094-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A5B3BA2348F
	for <lists+live-patching@lfdr.de>; Thu, 30 Jan 2025 20:18:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1829B1884BB8
	for <lists+live-patching@lfdr.de>; Thu, 30 Jan 2025 19:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B99E6188938;
	Thu, 30 Jan 2025 19:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mxts4S7A"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C36B660;
	Thu, 30 Jan 2025 19:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738264701; cv=none; b=ZnpoJOf/27RTQSeb+lcbO5AbVSDjIedCVhR8VLTA+WfKjK2F5cS2I0M1SM+j+2jzDIfK+hbRZOuIZsNYUDbJi27pst4fvc8NLsSeRnn4O8qTlWBBq8Hu76p01Do/CiPaXZYGKtD1f3SAgn0DsDhcHOLmALnJ5qru8Gi4RsY5+50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738264701; c=relaxed/simple;
	bh=F5UGl/zyxdIAV/PnK3hvp6JjpBmI+QG3xWDiGJq3kkQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OUUd0NFBRYxPVxOYJP9PwQCSaugxAm+v1SxSVO2pY3jxNrLVw5fM40kDwliZAc2PTT/KTyRzrsBuLmf8cpPoj0+kJaQyfd+GvQ6jjwbJbThrzI48OtVbyPIj+CVJU5MKkVjb4R1cc22WOCkWHyq/FBQdY228otZggPWUvsdWnNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mxts4S7A; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F4DC4CEE5;
	Thu, 30 Jan 2025 19:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738264701;
	bh=F5UGl/zyxdIAV/PnK3hvp6JjpBmI+QG3xWDiGJq3kkQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mxts4S7Asqr6bFnK/cRLSSQZiC6BwHs5f8TsYszYAMpuATd5EhwAEBBDyzWJ2IrT0
	 G594T75mOh9bqW4/ErnJDNBfbMvw9QvBPVcKGX3yn9LwvBSuskDU0Qt4pxXKKGPkRL
	 9TkVwAvv0nDqOuwNVBkejgpsCjiSm+JDy0VXIP0P29XdV73NmHQhPn9mZyWSGw/6TN
	 elQwnXV4GfDmgtfa+0Wu/dE3G7BpnLbGp9OqnvfXp2F65KUQf1WPMTQjcbcaWeM6Ed
	 So6O+DSjNRl3huYNpRdfspWIFEpHX2h5Naa2DLYKK08VK+DFwBtMbzwIr1Z5C3TKc/
	 LRK36OU36l01Q==
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3ce915a8a25so4390375ab.1;
        Thu, 30 Jan 2025 11:18:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVp4m2jsLrrpUzI8Q0Jm+u5iLg1wST25Fnm0mJB/bbP6/p9A0cIlz0DeGA5VW9kuoBDqAfpN/b4lJWpM9M06RzOQw==@vger.kernel.org, AJvYcCWNlUKQ2jZdD9O4VYbFHYLmZxX366c0452IWl1Lanzk3n8BR2avk8BJAJXcxrtkBI4COK8914UaI+ozNJw=@vger.kernel.org, AJvYcCXVZX0OSZkKmCiwS5bF13oUPzXLhOzBvvjnW6kPLPExq+/gvmWBvtZkzE+2wTrKIOzmYkFhJ2D9EgnC3I1gaA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7TDbQYSbpPsH0QGkiCjUe+KU6YpRzJY/3Lvqof+wwlpjJ1B5d
	FliWSL2QapeuZs6IYWoWQvcyqD03vmIpYUKVkQzYXpE+lapkzQQeCXf3GbdsI69sY3k3e3G8kWx
	Ejp0jTlbYXBlTH72emtK28VV95ho=
X-Google-Smtp-Source: AGHT+IHUAYnxNLSeDzHfkzX1E3E112OVV5uSNRIVJGtQAZwP0tGOWJ3I4OfIGX6ECRcDvvRqzClf1YSfKdpdBdzPRDY=
X-Received: by 2002:a05:6e02:1fe4:b0:3cf:c8ec:d375 with SMTP id
 e9e14a558f8ab-3cffe2680cemr69771655ab.0.1738264700324; Thu, 30 Jan 2025
 11:18:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127213310.2496133-1-wnliu@google.com> <CAPhsuW4UrhaYKj6pbAC9Cq1ZW+igFrA284nnCFsVdKdOfRpi6w@mail.gmail.com>
 <CAPhsuW7f5--hzr0Y3eb1JNpfNqepJuE92yq3y8dzaL_mQF+U5w@mail.gmail.com> <Z5vMfxFSIEtPMrMi@google.com>
In-Reply-To: <Z5vMfxFSIEtPMrMi@google.com>
From: Song Liu <song@kernel.org>
Date: Thu, 30 Jan 2025 11:18:09 -0800
X-Gmail-Original-Message-ID: <CAPhsuW76YZRBFgQf9PJ3OkaarbyDyWg=yXin9CXgNSwZYRnTZg@mail.gmail.com>
X-Gm-Features: AWEUYZmLoMdmanvQBUPm_vYlT3JWc_8Gli-r02xY9oR7T0OMt03HFwtkZr0PplE
Message-ID: <CAPhsuW76YZRBFgQf9PJ3OkaarbyDyWg=yXin9CXgNSwZYRnTZg@mail.gmail.com>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Weinan Liu <wnliu@google.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Indu Bhagat <indu.bhagat@oracle.com>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Roman,

On Thu, Jan 30, 2025 at 11:01=E2=80=AFAM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> On Thu, Jan 30, 2025 at 10:34:09AM -0800, Song Liu wrote:
> > On Thu, Jan 30, 2025 at 9:59=E2=80=AFAM Song Liu <song@kernel.org> wrot=
e:
> > >
> > > I missed this set before sending my RFC set. If this set works well, =
we
> > > won't need the other set. I will give this one a try.
> >
> > I just realized that llvm doesn't support sframe yet. So we (Meta) stil=
l
> > need some sframe-less approach before llvm supports sframe.
> >
> > IIRC, Google also uses llvm to compile the kernel. Weinan, would
> > you mind share your thoughts on how we can adopt this before
> > llvm supports sframe? (compile arm64 kernel with gcc?)
>
> Hi Song,
>
> the plan is to start the work on adding sframe support to llvm
> in parallel to landing these changes upstream. From the initial
> assessment it shouldn't be too hard.

Thanks for the information!

Song

