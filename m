Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D4D3337F7
	for <lists+live-patching@lfdr.de>; Wed, 10 Mar 2021 09:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhCJI4t (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 10 Mar 2021 03:56:49 -0500
Received: from mail.loongson.cn ([114.242.206.163]:46684 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230156AbhCJI4e (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 10 Mar 2021 03:56:34 -0500
Received: from [10.130.0.55] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9AxqdS7iUhgea4XAA--.30118S3;
        Wed, 10 Mar 2021 16:56:28 +0800 (CST)
Subject: Re: [PATCH RFC] MIPS: livepatch: Add LIVEPATCH basic code
To:     Miroslav Benes <mbenes@suse.cz>
References: <1614598201-17858-1-git-send-email-hejinyang@loongson.cn>
 <alpine.LSU.2.21.2103100912590.13355@pobox.suse.cz>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Xuefeng Li <lixuefeng@loongson.cn>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
From:   Jinyang He <hejinyang@loongson.cn>
Message-ID: <07945438-05b9-b62a-28eb-b91729ebf637@loongson.cn>
Date:   Wed, 10 Mar 2021 16:56:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.2103100912590.13355@pobox.suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9AxqdS7iUhgea4XAA--.30118S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF4fKryxKF47XF45Zw4xJFb_yoW8Ar43pF
        W5KFn3tw4DAr929rs7Zw4xWr15Z397Kr9xW3W8Wr1UZ3WDWw1SkFs2yw4qya45X34kKay3
        Z3y8tF1kZ3WkZa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvv14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
        Y487MxkIecxEwVAFwVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
        C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
        wI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjx
        v20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73Uj
        IFyTuYvjfUeHUDDUUUU
X-CM-SenderInfo: pkhmx0p1dqwqxorr0wxvrqhubq/
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 03/10/2021 04:18 PM, Miroslav Benes wrote:

> Hi,
>
> I cannot really comment on mips arch specifics but few words from the live
> patching perspective.
Thanks for your reply. :-)

>
> On Mon, 1 Mar 2021, Jinyang He wrote:
>
>> Add the basic code of livepatch. livepatch is temporarily unavailable.
>> Two core functions are missing, one is DYNAMIC_FTRACE_WITH_REGS, and
>> another is save_stack_trace_tsk_reliable().
>> `Huang Pei <huangpei@loongson.cn>` is doing for ftrace. He will use
>> `-fpatchable-function-entry` to achieve more complete ftrace.
> DYNAMIC_FTRACE_WITH_ARGS has been introduced recently, so you might also
> look at that. As far as the live patching is concerned,
> DYNAMIC_FTRACE_WITH_ARGS is sufficient.
Huang Pei had told me, and the follow link explains it detaily.
He is doing this work on mips arch now.

http://mpe.github.io/posts/2016/05/23/kernel-live-patching-for-ppc64le/

>> save_stack_trace_tsk_reliable() currently has difficulties. This function
>> may be improved in the future, but that seems to be a long time away.
>> This is also the reason for delivering this RFC. Hope to get any help.
> You may want to look at Documentation/livepatch/reliable-stacktrace.rst
> which nicely describes the requirements for the reliable stacktraces.
And Maciej answered many questions for me about reliable stacktrace.
I thought Documentation/livepatch/reliable-stacktrace.rst is important, too.
I noticed that arm64 has submitted objtool patches before, and it seems that
MIPS may use this method (ORC) to achieve reliable stack traceback. It looks
complicated to me. Drawf, compiler, abi and so on.

> Regards
> Miroslav
Thanks,
Jinyang

