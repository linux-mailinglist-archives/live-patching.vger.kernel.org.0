Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A4545D46E
	for <lists+live-patching@lfdr.de>; Thu, 25 Nov 2021 06:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346079AbhKYFyQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 25 Nov 2021 00:54:16 -0500
Received: from pegase2.c-s.fr ([93.17.235.10]:39353 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244237AbhKYFwP (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 25 Nov 2021 00:52:15 -0500
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4J06Pp0cprz9sSL;
        Thu, 25 Nov 2021 06:49:02 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cdg8mVz8UKXe; Thu, 25 Nov 2021 06:49:01 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4J06Pn6m3Sz9sSH;
        Thu, 25 Nov 2021 06:49:01 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id D089E8B778;
        Thu, 25 Nov 2021 06:49:01 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id sdQh_ZomDY8A; Thu, 25 Nov 2021 06:49:01 +0100 (CET)
Received: from [192.168.203.227] (unknown [192.168.203.227])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id D54728B763;
        Thu, 25 Nov 2021 06:49:00 +0100 (CET)
Message-ID: <b3c82c17-b659-a28d-b90b-8d353c7d4edd@csgroup.eu>
Date:   Thu, 25 Nov 2021 06:49:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v1 0/5] Implement livepatch on PPC32
Content-Language: fr-FR
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc:     live-patching@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
References: <cover.1635423081.git.christophe.leroy@csgroup.eu>
 <87r1b5p4hf.fsf@mpe.ellerman.id.au>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <87r1b5p4hf.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



Le 24/11/2021 à 23:34, Michael Ellerman a écrit :
> Christophe Leroy <christophe.leroy@csgroup.eu> writes:
>> This series implements livepatch on PPC32.
>>
>> This is largely copied from what's done on PPC64.
>>
>> Christophe Leroy (5):
>>    livepatch: Fix build failure on 32 bits processors
>>    powerpc/ftrace: No need to read LR from stack in _mcount()
>>    powerpc/ftrace: Add module_trampoline_target() for PPC32
>>    powerpc/ftrace: Activate HAVE_DYNAMIC_FTRACE_WITH_REGS on PPC32
>>    powerpc/ftrace: Add support for livepatch to PPC32
> 
> I think we know patch 5 will need a respin because of the STRICT RWX vs
> livepatching issue (https://github.com/linuxppc/issues/issues/375).
> 
> So should I take patches 2,3,4 for now?
> 

Yes you can take them now I think.

Thanks
Christophe
