Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB2EF2268
	for <lists+live-patching@lfdr.de>; Thu,  7 Nov 2019 00:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfKFXQd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 6 Nov 2019 18:16:33 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30172 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727080AbfKFXQd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 6 Nov 2019 18:16:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573082192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5tuNiF4QO0bwSBu7oymDSjgkRdbR3Qfk0s5KVbUvZoM=;
        b=F8Pomh5axd5LTT4cPgdXgKnhBVDiXSXiSulkH142vJi06KKbFF3nckryFF+az8b/1KQwdt
        wr1FIwJHrvOom1smqKS8YT/sSqJM0Ko0E/fvMt+v4bQWjNDxGmETCJ+kuoNGnf3qX3yVJF
        XxbI10qiPNM2nHK+PeWmlSFVjr7yAyc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-ObXpTYzpMbyrccMiwEOx3g-1; Wed, 06 Nov 2019 18:16:30 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4ADA1800D53;
        Wed,  6 Nov 2019 23:16:29 +0000 (UTC)
Received: from [10.18.17.119] (dhcp-17-119.bos.redhat.com [10.18.17.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BB1860870;
        Wed,  6 Nov 2019 23:16:29 +0000 (UTC)
Subject: Re: [PATCH] x86/stacktrace: update kconfig help text for reliable
 unwinders
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
References: <20191106224344.8373-1-joe.lawrence@redhat.com>
 <20191106230553.wnyltmkzwk5dph4l@treble>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <c8bae684-2a46-68e6-dc43-a8c215bdd111@redhat.com>
Date:   Wed, 6 Nov 2019 18:16:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191106230553.wnyltmkzwk5dph4l@treble>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: ObXpTYzpMbyrccMiwEOx3g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 11/6/19 6:05 PM, Josh Poimboeuf wrote:
> On Wed, Nov 06, 2019 at 05:43:44PM -0500, Joe Lawrence wrote:
>> commit 6415b38bae26 ("x86/stacktrace: Enable HAVE_RELIABLE_STACKTRACE
>> for the ORC unwinder") marked the ORC unwinder as a "reliable" unwinder.
>> Update the help text to reflect that change: the frame pointer unwinder
>> is no longer the only one that provides HAVE_RELIABLE_STACKTRACE.
>>
>> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
>> ---
>>   arch/x86/Kconfig.debug | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
>> index bf9cd83de777..69cdf0558c13 100644
>> --- a/arch/x86/Kconfig.debug
>> +++ b/arch/x86/Kconfig.debug
>> @@ -316,10 +316,6 @@ config UNWINDER_FRAME_POINTER
>>   =09  unwinder, but the kernel text size will grow by ~3% and the kerne=
l's
>>   =09  overall performance will degrade by roughly 5-10%.
>>  =20
>> -=09  This option is recommended if you want to use the livepatch
>> -=09  consistency model, as this is currently the only way to get a
>> -=09  reliable stack trace (CONFIG_HAVE_RELIABLE_STACKTRACE).
>> -
>>   config UNWINDER_GUESS
>>   =09bool "Guess unwinder"
>>   =09depends on EXPERT
>> @@ -333,6 +329,10 @@ config UNWINDER_GUESS
>>   =09  useful in many cases.  Unlike the other unwinders, it has no runt=
ime
>>   =09  overhead.
>>  =20
>> +=09  This option is not recommended if you want to use the livepatch
>> +=09  consistency model, as this unwinder cannot guarantee reliable stac=
k
>> +=09  traces.
>> +
>=20
> I'm not sure whether this last hunk is helpful.  At the very least the
> wording of "not recommended" might be confusing because it's not even
> possible to combine UNWINDER_GUESS+HAVE_RELIABLE_STACKTRACE.
>=20
> arch/x86/Kconfig:       select HAVE_RELIABLE_STACKTRACE         if X86_64=
 && (UNWINDER_FRAME_POINTER || UNWINDER_ORC) && STACK_VALIDATION
>=20

Ah good point.  The alternative would be to copy the recommended note to=20
both UNWINDER_FRAME_POINTER and UNWINDER_ORC, or at least remove the=20
"only" phrasing.  I dunno, nobody has noticed it yet, so maybe the first=20
hunk would be good enough.

-- Joe

