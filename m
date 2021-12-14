Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21362473DB5
	for <lists+live-patching@lfdr.de>; Tue, 14 Dec 2021 08:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhLNHfT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Dec 2021 02:35:19 -0500
Received: from pegase2.c-s.fr ([93.17.235.10]:33269 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231434AbhLNHfT (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Dec 2021 02:35:19 -0500
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4JCqsb0W8Dz9sSY;
        Tue, 14 Dec 2021 08:35:15 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id p2_EyWN4FEUC; Tue, 14 Dec 2021 08:35:14 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4JCqsZ6qRcz9sSF;
        Tue, 14 Dec 2021 08:35:14 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id D90C38B7B6;
        Tue, 14 Dec 2021 08:35:14 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id DouCIgz7vKoZ; Tue, 14 Dec 2021 08:35:14 +0100 (CET)
Received: from [192.168.233.42] (po13561.idsi0.si.c-s.fr [192.168.233.42])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 4F38E8B76C;
        Tue, 14 Dec 2021 08:35:14 +0100 (CET)
Message-ID: <aac75717-a3ac-c0b4-3e79-dc6eb9c26d8c@csgroup.eu>
Date:   Tue, 14 Dec 2021 08:35:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v1 0/5] Implement livepatch on PPC32
Content-Language: fr-FR
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
References: <cover.1635423081.git.christophe.leroy@csgroup.eu>
 <20211028093547.48c69dfe@gandalf.local.home>
 <6209682d-0caa-b779-8763-376a984d8ed8@csgroup.eu>
 <20211213121536.25e5488d@gandalf.local.home>
 <5511f43c-192a-622b-7c72-52e07f0032c2@csgroup.eu>
 <20211213123338.65eda5a0@gandalf.local.home>
 <fc3099b8-9f12-3e47-08a0-05abc37a0482@csgroup.eu>
 <20211213135410.12642d8f@gandalf.local.home>
 <8df90f94-9939-0178-b92b-6ae6ea81784c@csgroup.eu>
 <20211213144603.47d7c908@gandalf.local.home>
 <76ce2dd7-691e-df73-727c-110713c07cda@csgroup.eu>
In-Reply-To: <76ce2dd7-691e-df73-727c-110713c07cda@csgroup.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



Le 14/12/2021 à 07:09, Christophe Leroy a écrit :
> 
> 
> Le 13/12/2021 à 20:46, Steven Rostedt a écrit :
>> On Mon, 13 Dec 2021 19:33:47 +0000
>> Christophe Leroy <christophe.leroy@csgroup.eu> wrote:
>>
>>> STill the same Oops, below
>>
>> Unfortunately, I don't have a PPC machine (32 nor 64 bit) to help debug
>> this.
>>
>>
>>> I will look more closely tomorrow.
>>
>> OK, thanks.
>>
> 
> The Oops was due to ftrace_caller() setting the regs argument to NULL.
> 
> After fixing that, I'm back into a situation where I get "Testing tracer 
> function_graph: FAILED!"
> 
> Will continue investigating.
> 

trace_selftest_startup_function_graph() calls register_ftrace_direct() 
which returns -ENOSUPP because powerpc doesn't select 
CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS.

Should TEST_DIRECT_TRAMP depend on CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS ?

Christophe
