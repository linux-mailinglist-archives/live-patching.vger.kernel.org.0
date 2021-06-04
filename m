Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A3939C177
	for <lists+live-patching@lfdr.de>; Fri,  4 Jun 2021 22:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbhFDUme (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 4 Jun 2021 16:42:34 -0400
Received: from linux.microsoft.com ([13.77.154.182]:43380 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbhFDUme (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 4 Jun 2021 16:42:34 -0400
Received: from [192.168.254.32] (unknown [47.187.214.213])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8ECA920B7188;
        Fri,  4 Jun 2021 13:40:46 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8ECA920B7188
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1622839247;
        bh=UQyAxgPBVDlrjRRR30V2twGCDYKAC5fbsNqtB1zrWOc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=OOxTQYXouew83Kos/4G5y3PfoVPLC5YX/FeE6mOPw6znDtPEnxCPGwse2T89nZq61
         2iot+grdfC4QSU4jmWjIyozMGHk3v5oOvxGlAX1ef0QVuP57c/B/CtY0z+iUGNtnbD
         OT0CCjH0WEP7j7iUbiscoDSC75e7yarYXwNYq6sE=
Subject: Re: [RFC PATCH v5 2/2] arm64: Create a list of SYM_CODE functions,
 check return PC against list
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210526214917.20099-3-madvenka@linux.microsoft.com>
 <20210604165945.GA39381@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <39a46b62-7890-e952-3d77-756a53783176@linux.microsoft.com>
Date:   Fri, 4 Jun 2021 15:40:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210604165945.GA39381@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 6/4/21 11:59 AM, Mark Brown wrote:
> On Wed, May 26, 2021 at 04:49:17PM -0500, madvenka@linux.microsoft.com wrote:
> 
>> + *	- return_to_handler() is handled by the unwinder by attempting to
>> + *	  retrieve the original return address from the per-task return
>> + *	  address stack.
>> + *
>> + *	- kretprobe_trampoline() can be handled in a similar fashion by
>> + *	  attempting to retrieve the original return address from the per-task
>> + *	  kretprobe instance list.
>> + *
>> + *	- I reckon optprobes can be handled in a similar fashion in the future?
> 
> Note that there's a patch for optprobes on the list now:
> 
>    https://lore.kernel.org/r/1622803839-27354-1-git-send-email-liuqi115@huawei.com

Yes. I saw that.

Madhavan
