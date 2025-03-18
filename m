Return-Path: <live-patching+bounces-1291-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA5B2A67B6B
	for <lists+live-patching@lfdr.de>; Tue, 18 Mar 2025 18:54:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 939303AC50E
	for <lists+live-patching@lfdr.de>; Tue, 18 Mar 2025 17:54:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84D0A212D65;
	Tue, 18 Mar 2025 17:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E2RG4k+0"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6038B212B28
	for <live-patching@vger.kernel.org>; Tue, 18 Mar 2025 17:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742320476; cv=none; b=o/ZcEBKfjFC0YXCUX6SoVPEK60rnZjNGPrK45CMN/its68Sf9ypAHwEEJVTd4GbyuWm1mzwF8TbOxqvUj+2RerBLOfUl2PPCTVJvXoQVKLUkE7jHtRLyR2bAbqiFCJsglxei27mr5YFYNXCtWGEzmBnfUCVml/+4RiA/VqnOdIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742320476; c=relaxed/simple;
	bh=riASSUdIoStW4wgImMx1VhQXOUl/yMfQTaO2AvS1dRc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sbL2tRSULCVfMqzHbd77Rjg5jQFWm9QvZ4PmtZrycEQEOSbPoI5cb6gBr5CQEjOEK34RrwAEYyzjpwX/38H2ZS9sPHBiR4feSiivhuq1TugH66V7xQiJ9OKxoyO7enI7DPnfDSfiyTBi/9dLksyow3Ahh123lUZBgKu4yeYP/oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E2RG4k+0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0170C4CEDD
	for <live-patching@vger.kernel.org>; Tue, 18 Mar 2025 17:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742320474;
	bh=riASSUdIoStW4wgImMx1VhQXOUl/yMfQTaO2AvS1dRc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=E2RG4k+0OG7VV13KkYnbBjBwfzt7rQ+c1cPI56f02JRoFZIU+lcWWzPJuKzrQ2HpA
	 f0oiLOqzxjO9ZLOiDNqXkcLLZpL//Oqa/FCSsMnY8IMgS4mvIBNHzod+T7kGo1PeDg
	 ipL9WmYTKSsURKDoziIv/b8TzEpr58F77tcCFR/oTsUKiOeVqw1tP+VxhXxUk4PJN2
	 k0KD35vTIleu+7zIivx2ASnidvnpjQKVjWjR/SwH2PIjhx+VyBGamI5ijkkLX7RncZ
	 a9HWUs9/ksu0qaDkqDc1LyJurTcDZliWT9ueXSkVmaBN6ZMnpi8wdNulJqJnGK38je
	 Tj8iVXIwXgWJQ==
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3cfeff44d94so21389605ab.0
        for <live-patching@vger.kernel.org>; Tue, 18 Mar 2025 10:54:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVj8By0R4etEvcVTYGdJW1Z4DQwAH2Q5atRM8BKRMHnjyA+y/gZkq90D8zZaqi02QW95Kcu9nQh3S+g/jpE@vger.kernel.org
X-Gm-Message-State: AOJu0Yzu0gJ+TEQa8UDxir1EAeOlbAWILHXqzdt/S+wejNpnpn1JzP8z
	Bn3zciSSO/aZGsvtRxrOsCoKITW4lYPcNlDmUm/PjhZizcRaxDbLExYfY3zG/7rG8U2+Zn0jK/v
	k/iPJI2FkP1i+MT1jfpJ/zWMFHco=
X-Google-Smtp-Source: AGHT+IGjhEUwG5lNNTeySPG5AjiAwFAzzFpdfoV61y8sfAPR3xeGm51a6PI3dC57lx7eMOZolNgPwgIz6Kykbuc4+lg=
X-Received: by 2002:a05:6e02:3b49:b0:3d4:3ab3:daf5 with SMTP id
 e9e14a558f8ab-3d57b9c526cmr45635575ab.6.1742320474260; Tue, 18 Mar 2025
 10:54:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250317165128.2356385-1-song@kernel.org> <2862567f-e380-a580-c3be-08bd768384f9@redhat.com>
 <CAPhsuW6UdBHHZA+h=hCctkL05YU7xpQ3uZ3=36ub5vrFYRNd5A@mail.gmail.com>
 <alpine.LSU.2.21.2503181112380.16243@pobox.suse.cz> <Z9l4zJKzXHc51OMO@redhat.com>
In-Reply-To: <Z9l4zJKzXHc51OMO@redhat.com>
From: Song Liu <song@kernel.org>
Date: Tue, 18 Mar 2025 10:54:22 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4Ke718yQhPumNSYNhhnCPbY7FK=Uv6J1kNLu5ogEpxXA@mail.gmail.com>
X-Gm-Features: AQ5f1JrbrziZEr7TT4Lv9RFPha0T6-ksCDPiyqt6NThZU0jL9IP16_lIwMQigjw
Message-ID: <CAPhsuW4Ke718yQhPumNSYNhhnCPbY7FK=Uv6J1kNLu5ogEpxXA@mail.gmail.com>
Subject: Re: [PATCH] selftest/livepatch: Only run test-kprobe with CONFIG_KPROBES_ON_FTRACE
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org, jpoimboe@kernel.org, 
	kernel-team@meta.com, jikos@kernel.org, pmladek@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 18, 2025 at 6:45=E2=80=AFAM Joe Lawrence <joe.lawrence@redhat.c=
om> wrote:
[...]
> Kallsyms is a good workaround as kprobe_ftrace_ops should be stable (I
> hope :)
>
> Since Song probably noticed this when upgrading and the new kprobes test
> unexpectedly failed, I'd add a Fixes tag to help out backporters:
>
>   Fixes: 62597edf6340 ("selftests: livepatch: test livepatching a kprobed=
 function")
>
> but IMHO not worth rushing as important through the merge window.

I actually think this fix is simple enough that I would not worry about it
breaking anything in 6.15. But if other folks agree this is too late for 6.=
15,
I don't mind waiting until 6.16.

Thanks,
Song

