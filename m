Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E438C33C648
	for <lists+live-patching@lfdr.de>; Mon, 15 Mar 2021 20:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhCOTBp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 15 Mar 2021 15:01:45 -0400
Received: from linux.microsoft.com ([13.77.154.182]:38864 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbhCOTBa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 15 Mar 2021 15:01:30 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 1C911209B9A6;
        Mon, 15 Mar 2021 12:01:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1C911209B9A6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1615834889;
        bh=Ic1hDlWv1nIWRstu4/+c348Zho3rZmFdZ9ivJNtRAd4=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=hgCNvZstRpexvpdiajk/yrZENpRiE27Ddiz9cuEO1Z/hJeKCI5CVHYEM31lWDhQi7
         IzDDdCK5ifzxQMMb1tw7WZlovdFvMUQPiqyKkUEof051Q5F1PXBS1wEhdVqGptVAH1
         KvOAmJRrrx2LKWDxz9upv4PfmmrdvKnA73dRyAsA=
Subject: Re: [RFC PATCH v2 0/8] arm64: Implement reliable stack trace
To:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <1328e64e-11c3-1391-e56d-97ee9b322f6d@linux.microsoft.com>
Date:   Mon, 15 Mar 2021 14:01:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210315165800.5948-1-madvenka@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 3/15/21 11:57 AM, madvenka@linux.microsoft.com wrote:
> Proper termination of the stack trace
> =====================================
> 
> In the unwinder, check the following for properly terminating the stack
> trace:
> 
> 	- Check every frame to see if it is task_pt_regs(stack)->stackframe.
> 	  If it is, terminate the stack trace successfully.
> 

There is a typo in the above sentence. task_pt_regs(stack)->stackframe
should be task_pt_regs(task)->stackframe.

Sorry about that.

Madhavan
