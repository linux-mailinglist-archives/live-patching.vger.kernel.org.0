Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D9B1A7830
	for <lists+live-patching@lfdr.de>; Tue, 14 Apr 2020 12:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438185AbgDNKMq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Apr 2020 06:12:46 -0400
Received: from mail.alicef.me ([219.94.233.166]:52134 "EHLO mail.alicef.me"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438130AbgDNKMp (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Apr 2020 06:12:45 -0400
X-Greylist: delayed 547 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Apr 2020 06:12:44 EDT
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id EC925222B8;
        Tue, 14 Apr 2020 19:03:23 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alicef.me; s=dkim;
        t=1586858606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1EtgEbXUPidrJ3KNxNCAA/ujW9mGww6taEMNQehMGq0=;
        b=pPW3RhrHyLSDNCnPpzDg0ggySNA7wVTSqorT8SAaPcR2OPNsOiipmUO2f4fa3s+PUWRr/Q
        KZyhz9j3mP7hQMJteywsTYTq+l7KbThnv/MLh7QZI4+O20flER5rLtF3GTc75g0rKNo1K/
        CikIZCzoqUkK3uieYgFvwHQrFTV6VS8jIzyIe2NQcun/2FqNQoTBv2MuK9Ytip0n5V2X1Z
        j7SNFEIycfjn14GPVKnfO3SntoSRQoWxjkc+K7ha16CxEzfBQDm32FNn0pfMnBsdp+remy
        82mTErY5xobEyTLKeoYAZSsWTpw0AJnN+q3d+Ss2puJqg1dlL153/tqR3QRUrA==
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (1.0)
Subject: Re: Live patching MC at LPC2020?
From:   Alice ferrazzi <alicef@alicef.me>
In-Reply-To: <57a1a529-3afb-988e-f5a8-f979d8a1fe12@linux.vnet.ibm.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Nicolai Stange <nstange@suse.com>,
        Jason Baron <jbaron@akamai.com>,
        Gabriel Gomes <gagomes@suse.com>, Michael Matz <matz@suse.de>,
        ulp-devel@opensuse.org
Date:   Tue, 14 Apr 2020 19:03:07 +0900
Message-Id: <0FB3F062-0E9F-40E6-836A-197DB9991045@alicef.me>
References: <57a1a529-3afb-988e-f5a8-f979d8a1fe12@linux.vnet.ibm.com>
To:     live-patching@vger.kernel.org
X-Last-TLS-Session-Version: TLSv1.3
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


hello everyone,

> 2020/04/08 19:23=E3=80=81Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>=E3=
=81=AE=E3=83=A1=E3=83=BC=E3=83=AB:
>=20
> =EF=BB=BFOn 4/1/20 2:22 AM, Joe Lawrence wrote:
>>>> On Fri, Mar 27, 2020 at 02:20:52PM +0100, Jiri Kosina wrote:
>>>> Hi everybody,
>>>> oh well, it sounds a bit awkward to be talking about any conference pla=
ns
>>>> for this year given how the corona things are untangling in the world, b=
ut
>>>> LPC planning committee has issued (a) statement about Covid-19 (b) call=

>>>> for papers (as originally planned) nevertheless. Please see:
>>>>   https://linuxplumbersconf.org/
>>>>   https://linuxplumbersconf.org/event/7/abstracts/
>>>> for details.
>>>> Under the asumption that this Covid nuisance is over by that time and
>>>> travel is possible (and safe) again -- do we want to eventually submit a=

>>>> livepatching miniconf proposal again?
>>>> I believe there are still kernel related topics on our plate (like revi=
sed
>>>> handling of the modules that has been agreed on in Lisbon and Petr has
>>>> started to work on, the C parsing effort by Nicolai, etc), and at the s=
ame
>>>> time I'd really like to include the new kids on the block too -- the
>>>> userspace livepatching folks (CCing those I know for sure are working o=
n
>>>> it).
>> Hi Jiri,
>> First off, I hope everyone is riding out COVID-19 as well as possible,
>> considering all that's happening.
>> As for LPC mini-conf topics, I'd be interested in (at least):
>> - Petr's per-object livepatch POC
>> - klp-convert status
>> - objtool hacking
>> - Nicolai's klp-ccp status
>> - arch update (arm64, etc)
>=20
> Hi Jiri,
>=20
> I hope everyone is keeping safe. I would be interested in the topics liste=
d
> by Joe and in userspace patching.


I'm also interested in userspace patching.

>=20
>>> So, please if you have any opinion one way or the other, please speak up=
.
>>> Depending on the feedback, I will be fine handling the logistics of the
>>> miniconf submission as last year (together with Josh I guess?) unless
>>> someone else wants to step up and volunter himself :)
>>> (*) which is totally unclear, yes -- for example goverment in my country=

>>>   has been talking for border closure lasting for 1+ years ... but it
>>>   all depends on how things develop of course).
>> Hmm, all good points.  Some conferences have gone virtual to cope with
>> necessary cancellations, but who knows what things will look like even
>> at the end of August.  Perhaps we can still do something remotely if the
>> conditions dictate it.  But my vote would be yes, and let's see what
>> topics interest folks.
>=20
> Regards,
> Kamalesh

thanks,
Alice=
