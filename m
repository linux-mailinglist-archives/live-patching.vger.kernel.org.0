Return-Path: <live-patching+bounces-3-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 082D97A9879
	for <lists+live-patching@lfdr.de>; Thu, 21 Sep 2023 19:47:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5CAB28276C
	for <lists+live-patching@lfdr.de>; Thu, 21 Sep 2023 17:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3414416414;
	Thu, 21 Sep 2023 17:22:32 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BAA14F76
	for <live-patching@vger.kernel.org>; Thu, 21 Sep 2023 17:22:28 +0000 (UTC)
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C6F4F907
	for <live-patching@vger.kernel.org>; Thu, 21 Sep 2023 10:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1695299186;
	bh=bC6X1py1SuoJtQxgFRw2Ryvn0wAzoIONYvfkgObrO/E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=b687BW/TgpeWKwniyy7LJa+Q+crc7hK9dcN5nxIiKaTQwPR20r4+nJoMYJ7svqNCj
	 /9RmYxIq7saR8Kb1/TIP2XEODSZ4i5hv8Q/hZeq7pF11pfpX5EG7q1Ib7+4WXf6b2Q
	 8A7PwdhUfkL042R8T1EpbwTr+S5QU+MY4gwQ/D/+Jhje4RjhdUNe7v4w4rDLoIRrDx
	 s08TCC0peYnEmH8y4ZL3QgHOv3QQcIu5t8azjGBN2Ko+2/C5eKQHnbVvMwhyhxAywb
	 8wqnarIilxNt6r1mqCBJ+jahygWV0uJGWRAKev5Wx5qUJzMjPWTsO/6HidLroKFqhB
	 RpNBBqLs/S+hw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4RrvlP6nYLz4wy9;
	Thu, 21 Sep 2023 22:26:25 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Petr Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org, live-patching@vger.kernel.org, Ryan
 Sullivan <rysulliv@redhat.com>, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: Recent Power changes and stack_trace_save_tsk_reliable?
In-Reply-To: <ZQr-vmBBQ66TRobQ@alley>
References: <ZO4K6hflM/arMjse@redhat.com> <87o7ipxtdc.fsf@mail.lhotse>
 <87il8xxcg7.fsf@mail.lhotse>
 <cca0770c-1510-3a02-d0ba-82ee5a0ae4f2@redhat.com> <ZQr-vmBBQ66TRobQ@alley>
Date: Thu, 21 Sep 2023 22:26:22 +1000
Message-ID: <8734z7ogpd.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Petr Mladek <pmladek@suse.com> writes:
> On Wed 2023-08-30 17:47:35, Joe Lawrence wrote:
>> On 8/30/23 02:37, Michael Ellerman wrote:
>> > Michael Ellerman <mpe@ellerman.id.au> writes:
>> >> Joe Lawrence <joe.lawrence@redhat.com> writes:
>> >>> We noticed that our kpatch integration tests started failing on ppc64le
>> >>> when targeting the upstream v6.4 kernel, and then confirmed that the
>> >>> in-tree livepatching kselftests similarly fail, too.  From the kselftest
>> >>> results, it appears that livepatch transitions are no longer completing.
...
>> > 
>> > The diff below fixes it for me, can you test that on your setup?
>> > 
>> 
>> Thanks for the fast triage of this one.  The proposed fix works well on
>> our setup.  I have yet to try the kpatch integration tests with this,
>> but I can verify that all of the kernel livepatching kselftests now
>> happily run.
>
> Have this been somehow handled, please? I do not see the proposed
> change in linux-next as of now.

I thought I was waiting for Joe to run the kpatch integration tests, but
in hindsight maybe he was hinting that someone else should run them (ie. me) ;)

Patch incoming.

cheers

